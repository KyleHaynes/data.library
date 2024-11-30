
# create_manifest <- function(
#      d
#    , path = "c:/temp/gnap"
#    , create_markdown = TRUE
#    , create_json = TRUE
#    , create_quarto = TRUE
#    , dataset_name = "a short description"
#    , short_description = "a short description"
#    , long_description = "a long description"
#    , version = "2023.01"
#    , inception_date = "2023-01-01"
#    , updated_date = "2023-01-01"
#    , creation_date = "2023-01-01"
#    , steakholders = c("cust 1", "cust 2", "cust 3")
#    , users = c("user 1", "cust 2", "cust 4")
#    , variables = list(
#                      "ADDRESS_DETAIL_PID" = list("sss" = "1", "b" = "d"),
#                      "LOCALITY_NAME" = list("sss" = "blah", "b" = "d")
#                  )
#    , ...
# ){
#     if(exists("short_description") && !is.na(short_description)){
#         cli_alert_success("Short Description: {.val {short_description}}.")
#     } else {
#         cli_alert_info("`short_description` not defined.")
#     }

#     if(exists("long_description") && !is.na(long_description)){
#         cli_alert_success("Long Description: {.val {long_description}}.")
#     } else {
#         cli_alert_info("`long_description` not defined.")
#     }

#     if(exists("version") && !is.na(version)){
#         cli_alert_success("Version: {.val {version}}.")
#     } else {
#         cli_alert_info("`version` not defined.")
#     }

#     if(exists("inception_date") && !is.na(inception_date)){
#         cli_alert_success("Inception date: {.val {inception_date}}.")
#     } else {
#         cli_alert_info("`inception_date` not defined.")
#     }

#     if(exists("updated_date") && !is.na(updated_date)){
#         cli_alert_success("Updated date: {.val {updated_date}}.")
#     } else {
#         cli_alert_info("`updated_date` not defined.")
#     }

#     if(exists("creation_date") && !is.na(creation_date)){
#         cli_alert_success("Creation date: {.val {creation_date}}.")
#     } else {
#         cli_alert_info("`creation_date` not defined.")
#     }

#     if(exists("steakholders") && !is.na(steakholders[1])){ #TODO: Improve validation
#         cli_alert_success("Steakholders: {.val {steakholders}}.")
#     } else {
#         cli_alert_info("`steakholders` not defined.")
#     }

#     if(exists("users") && !is.na(users)[1]){
#         cli_alert_success("Users: {.val {users}}.")
#     } else {
#         cli_alert_info("`users` not defined.")
#     }

#     browser()

#     # Return the arguments
#     md <- c(formals(), list(...))
#     md$fuk = NULL

#     if(create_markdown){

#     }

#     # cli_alert_info("Short Description {.emph nbld}  in tbld.")

# # cli_alert_success("Short Description {.emph {nbld}} status report{?s} in {tbld}.")
# # cli_alert_info("Short Description {.emph {nbld}} status report{?s} in {tbld}.")
# # cli_alert_info("Data columns: {.val {names(mtcars)}}.")
# # cli_alert_info("Data columns: {.val {names(mtcars)}}.")
# # cli_alert_success("Short Description: {.val {short_description}}.")
# # browser()
# }

# create_markdown <- function(x = md){

#     for(i in 1:length(x)){
#         if(i == 1){
#              md_path <- normalizePath(paste0(x$path, "/README.md"), mustWork = FALSE)
#              write("", file = md_path, append = FALSE)
#         }
#         browser()
#         if(x[[i]] == "" || is.na(x[[i]][1]) || is.null( x[[i]] == "")) next

#         if(length(x[[i]] == 1)){
#             names(x[i])
#         }
#         write("", file = md_path, append = FALSE)

#     }
# }


# create_markdown

# create_manifest(, fuk = "blah")

