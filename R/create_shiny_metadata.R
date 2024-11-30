# Load necessary libraries
library(shiny)
library(jsonlite)
# Load necessary libraries
library(shiny)
library(jsonlite)
library(bslib)

#' Create metadata in Shiny
#'
#' @description
#' Create metadata in Shiny.

#' @param path Folder path of where the data will be output.
#' 
#' @param vars_regex Regex pattern to match variable names to input.
#' 
#' @param vars_vec A vector of of variable names to input.
#' 
#' @param verbose Logical argument to be verbose.

#' @import data.table shiny jsonlite bslib

create_shiny_metadata <- function(obj = letters, var_criteria) {

    var_criteria <- list(
                    identifier = "",
                    other_context = "",
                    foobar = Sys.Date()
                )

    # Get the name of the passed object
    object_to_change <- deparse(substitute(obj)) 

    # Get the object from a given environment
    val <- get(object_to_change, envir = .GlobalEnv) 
    var_criteria <<- var_criteria 

    # Save the object as a reactive value
    values <- reactiveValues(x = val)                                   
    values <- reactiveValues(var_criteria = var_criteria)                                   
    # Enable thematic
    # thematic::thematic_shiny(font = "auto")

    # Define the UI using bslib
    ui <- fluidPage(
        # Use bslib for Bootstrap 5 theming
        titlePanel("Edit Metadata Information"),
        theme = bs_theme(
            bootswatch = "darkly",
            base_font = font_google("Inter"),
            navbar_bg = "#25443B"
        ),
        # !!!cards,
        # Title
        # sidebar = color_by,
        # Layout for collecting metadata and dataset information
        sidebarLayout(
            sidebarPanel(
                # Inputs for Dataset Information
                textInput("dataset_name", "Dataset Name", value = "Health Data"),
                textAreaInput("dataset_description", "Dataset Description", 
                              value = "This dataset contains clinical and administrative health data, including demographic information."),
                
                # Field to enter the name of a new variable
                textInput("new_var_name", "Define New Variable Name", value = ""),
                actionButton("add_variable", "Add New Variable"),
                
                # Dropdown to select the variable to edit
                uiOutput("variable_select_ui"),
                
                # Save and Download Buttons
                actionButton("save_button", "Save Changes"),
                downloadButton("download_json", "Download All Metadata as JSON")
            ),
            
            mainPanel(
                h3("Current Data"),
                uiOutput("variable_edit_ui"),
                uiOutput("current_data")
            )
        )
    )

    # Define the server logic
    server <- function(input, output, session) {

        # Reactive values to store the dataset and variables' metadata
        metadata <- reactiveValues(
            dataset = list(
                name = "Health Data",
                description = "This dataset contains clinical and administrative health data, including demographic information."
            ),
            variables = list(val)  # To store metadata for user-defined variables
        )
        
        # Observe the add new variable button
        observeEvent(input$add_variable, {
            new_var_name <- input$new_var_name
            new_var_name <- val
            
            # Check if the new variable name is not empty and doesn't already exist
            if (T) {
                for(i in val) {
                    # Add new variable metadata structure to the list
                    metadata$variables[[i]] <- var_criteria
                }
                
                # Clear the input for new variable name
                updateTextInput(session, "new_var_name", value = "")
                
                # Update the dropdown for selecting variables
                updateSelectInput(session, "variable_select", choices = names(metadata$variables))
            }
        })
        
        # Dynamic dropdown to select which variable to edit
        output$variable_select_ui <- renderUI({
            selectInput("variable_select", "Select Variable", 
                        choices = names(metadata$variables), 
                        selected = if (length(names(metadata$variables)) > 0) names(metadata$variables)[1] else NULL)
        })
        
        # Render the UI for editing the selected variable's metadata
        predefined_fields <- var_criteria
        
        output$variable_edit_ui <- renderUI({
            selected_variable <- input$variable_select
            
            if (!is.null(selected_variable)) {
                # Generate input fields dynamically for the selected variable
                tagList(
                    lapply(names(predefined_fields), function(field) {
                        field_label <- field
                        field_value <- metadata$variables[[selected_variable]][[field]]
                        
                        # Use the correct input type based on the field name
                        if (field %in% c("approval_date", "effective_from", "effective_to")) {
                            # Date fields: Use dateInput for date type fields
                            return(dateInput(paste0(selected_variable, "_", field), field_label, value = field_value))
                        } else if (field == "definition") {
                            # Text area for "definition"
                            return(textAreaInput(paste0(selected_variable, "_", field), field_label, value = field_value))
                        } else {
                            # Default: Use textInput for other fields
                            return(textInput(paste0(selected_variable, "_", field), field_label, value = field_value))
                        }
                    })
                )
            }
        })
        
        # Render the metadata of the selected variable
        output$current_data <- renderUI({
            tagList(
                p(strong("Dataset Name: "), metadata$dataset$name),
                p(strong("Dataset Description: "), metadata$dataset$description),
                hr(),
                lapply(names(metadata$variables), function(var_name) {
                    tagList(
                        h4(var_name),
                        # Loop through predefined fields to display metadata for each variable
                        lapply(names(predefined_fields), function(field) {
                            field_label <- predefined_fields[[field]]
                            field_value <- metadata$variables[[var_name]][[field]]
                            
                            # Display the field name and value
                            p(strong(field_label), field_value)
                        }),
                        hr()
                    )
                })
            )
        })
        
        # Observe the save button and update the reactive values for the selected variable and dataset
        observeEvent(input$save_button, {
            selected_variable <- input$variable_select
            
            if (!is.null(selected_variable)) {
                # Update metadata for the selected variable
                for(i in names(predefined_fields)) {
                    metadata$variables[[selected_variable]][i] <- input[[paste0(selected_variable, "_", i)]]
                }
            }
            
            # Update dataset information
            metadata$dataset$name <- input$dataset_name
            metadata$dataset$description <- input$dataset_description
        })
        
        # Create the JSON data when the download button is clicked
        output$download_json <- downloadHandler(
            filename = function() {
                paste("metadata_", Sys.Date(), ".json", sep = "")
            },
            content = function(file) {
                # Create a list of metadata for all variables and the dataset information
                all_metadata <- list(
                    dataset = metadata$dataset,
                    variables = metadata$variables
                )
                
                # Convert the list to JSON and write it to the specified file
                write_json(all_metadata, path = file, pretty = TRUE)
            }
        )
    }

    # Run the Shiny app
    shinyApp(ui = ui, server = server)
}

