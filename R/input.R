#' Input data
#'
#' @description
#' Output data to *.RDS objects.

#' @param path Folder path of where the data will be output.
#' 
#' @param vars_regex Regex pattern to match variable names to input.
#' 
#' @param vars_vec A vector of of variable names to input.
#' 
#' @param verbose Logical argument to be verbose.

#' @import data.table

#' @export
input <- function(path = "c:/temp/gnap", vars_regex = NULL, vars_vec = NULL, verbose = TRUE){

    if(is.null(vars_regex) && is.null(vars_vec) && verbose){
        message("`vars_regex` and `vars_vec` are NULL, importing all variables.")
    }
    
    # Normalise the path.
    path <- normalizePath(path, mustWork = TRUE)

    # Get path of all RDS objects.
    # TODO: improve with manifest.
    paths <- data.table(
        file_paths = normalizePath(list.files(path = path, full.names = TRUE, pattern = "rds_.*\\.rds$", ignore.case = TRUE))
    )
    
    # Derive the variable name
    paths[, var_name := gsub(".*rds_|\\.rds", "", file_paths, ignore.case = TRUE, perl = TRUE)]

    # If regex is not NULL, subset to regex vars
    if(!is.null(vars_regex)){
        paths[, import := fifelse(grepl(vars_regex, var_name, perl = TRUE), TRUE, FALSE)]
    } else if(!is.null(vars_vec)){
        paths[, import := fifelse(var_name %in% vars_vec, TRUE, FALSE)]
    } else {
        paths[, import := TRUE]
    }


    if(verbose){
        cli::cli_alert_info("Importing the following variables: {.val {paths[(import)]$var_name}}.", wrap = TRUE)
        cli::cli_alert_warning("Not importing the following variables: {.val {paths[(!import)]$var_name}}.", wrap = FALSE)
    }

    paths <- paths[(import)]

    # Error if no vars
    if(nrow(paths) == 0){
        stop("No variables detected.")
    }

    # Overall time recording.
    o_time_start <- Sys.time()

    d <- data.table()

    # Output individual RDS objects.
    for(i in 1:nrow(paths)) {
        # Start time.
        time_start <- Sys.time()
        # Read *.rds files
        set(d, i = NULL, j = paths[i]$var_name, value = readRDS(paths[i]$file_paths))
        # And if `verbose`, print output.
        if(verbose) { 
            cli::cli_alert_info("Imported `{.emph {paths[i]$var_name}}`` in {.emph {round(difftime(Sys.time(), time_start, units = 'mins'), 2)}} minutes.")
            flush.console()
        }
    }

    if(verbose) {
        cli::cli_alert_info("Folder last modifed: {.emph {file.info(path)$mtime}}.")
        cli::cli_alert_info("Overall time taken: {.emph {round(difftime(Sys.time(), o_time_start, units = 'mins'), 2)}} minutes.")
    }

    return(d)
}
