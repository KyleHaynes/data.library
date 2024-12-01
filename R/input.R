#' Input data
#'
#' @description
#' Output data to *.RDS objects.

#' @param path Folder path of where the data will be output.
#' 
#' @param vars_regex Regex pattern to match variable names to input.
#' 
#' @param vars_vec A vector of variable names to input.
#' 
#' @param verbose Logical argument to be verbose.

#' @import data.table

#' @export
input <- function(path = getOption("data.library.path"), vars_regex = NULL, vars_vec = NULL, verbose = TRUE){

    if(is.null(path)){
        stop("No `path`` defined. Either define `path` or set `options(\"data.library.path\" = \"./path/to/data\")`")
    }

    if(is.null(vars_regex) && is.null(vars_vec) && verbose){
        cli::cli_alert_info("`vars_regex` and `vars_vec` are NULL, importing all variables.")
    }
    
    # Normalise the path.
    path <- normalizePath(path, mustWork = TRUE)

    # Define the spec path.
    sys_path <- normalizePath(paste0(path, "/.data.library/data.library.spec.rds"), mustWork = FALSE)

    if(file.exists(sys_path)){
        spec <- readRDS(sys_path)
        spec_exists <- TRUE
    } else {
        cli::cli_alert_warning("No specification file detected. Variable order will likely not match original dataset. Data will be returned as a `data.table`.", wrap = TRUE)
        spec_exists <- FALSE
    }

    # Get path of all RDS objects.
    # TODO: improve with manifest.
    if(spec_exists){
        paths <- data.table(
            file_paths = normalizePath(list.files(path = path, full.names = TRUE, pattern = "rds_.*\\.rds$", ignore.case = TRUE))
        )
        # Derive the variable name
        paths[, var_name := gsub(".*rds_|\\.rds", "", file_paths, ignore.case = TRUE, perl = TRUE)]
        # Subset to just spec vars.
        paths <- paths[var_name %in% spec$var_order]
    } else {
        paths <- data.table(
            file_paths = normalizePath(list.files(path = path, full.names = TRUE, pattern = "rds_.*\\.rds$", ignore.case = TRUE))
        )
        # Derive the variable name
        paths[, var_name := gsub(".*rds_|\\.rds", "", file_paths, ignore.case = TRUE, perl = TRUE)]
    }


    # If regex is not NULL, subset to regex vars
    if(!is.null(vars_regex)){
        paths[, import := fifelse(grepl(vars_regex, var_name, perl = TRUE), TRUE, FALSE)]
    } else if(!is.null(vars_vec)){
        paths[, import := fifelse(var_name %in% vars_vec, TRUE, FALSE)]
    } else {
        paths[, import := TRUE]
    }

    # Error if no vars
    if(nrow(paths[(import)]) == 0){
        stop("No variables detected.")
    }

    # If verbose, communicate what vars are/are not getting inputted.
    if(verbose){
        cli::cli_alert_info("Importing the following variables: {.val {paths[(import)]$var_name}}.", wrap = TRUE)
        if(nrow(paths[(!import)]) >= 1) cli::cli_alert_warning("Not importing the following variables: {.val {paths[(!import)]$var_name}}.", wrap = FALSE)
    }

    # Subset to just vars getting inputted.
    paths <- paths[(import)]

    # Overall time recording.
    o_time_start <- Sys.time()

    # Create empty data.table to bind to.
    d <- data.table()

    # Output individual RDS objects.
    for(i in 1:nrow(paths)) {
        # Start time.
        time_start <- Sys.time()
        # Read *.rds files
        set(d, i = NULL, j = paths[i]$var_name, value = readRDS(paths[i]$file_paths))
        # And if `verbose`, print output.
        if(verbose) {
            if(
                exists("spec") && 
                spec$metadata[1] != FALSE && 
                !is.null(short <- spec$metadata$variables[[paths$var_name[i]]]$short_description)
            ){
                cli::cli_alert_info("Imported `{.emph {paths[i]$var_name}}`` in {.emph {round(difftime(Sys.time(), time_start, units = 'mins'), 2)}} minutes.\n    - {short}")
            } else {
                cli::cli_alert_info("Imported `{.emph {paths[i]$var_name}}`` in {.emph {round(difftime(Sys.time(), time_start, units = 'mins'), 2)}} minutes.")
            }
            flush.console()
        }
    }

    if(spec_exists){
        setcolorder(d, spec$var_order[spec$var_order %in% names(d)])
        if(spec$object_class == "data.frame"){
            d <- data.frame(d)
            row.names(d) <- spec$row.names
        } else if (spec$object_class == "tibble"){
            d <- tibble::tibble(d)
        }
    }

    if(verbose) {
        cli::cli_alert_info("Folder last modified: {.emph {file.info(path)$mtime}}.")
        cli::cli_alert_info("Overall time taken: {.emph {round(difftime(Sys.time(), o_time_start, units = 'mins'), 2)}} minutes.")
    }

    return(d)
}
