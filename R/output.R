#' Output data
#'
#' @description
#' Output data to *.RDS objects.

#' @param d data.table to export.
#' 
#' @param path Folder path of where the data will be output.
#' 
#' @param verbose Logical argument to be verbose.

#' @import data.table

#' @export
output <- function(d, path = getOption("data.library.path"), verbose = TRUE, ...) {

    if(is.null(path)){
        stop("No `path`` defined. Either define `path` or set `options(\"data.library.path\" = \"./path/to/data\")`")
    }

    # Determine data type.
    data_class <- fcase(
        tibble::is_tibble(d), "tibble",
        is.data.table(d), "data.table",
        is.data.frame(d), "data.frame"
    )
    
    # Save row.names if a data.frame
    if(data_class == "data.frame"){ 
        row_names <- row.names(d)
    } else {
        row_names <- FALSE
    }
    
    # Coerce to data.table
    d <- data.table(d)

    # Normalise the path.
    path <- normalizePath(path, mustWork = FALSE)
    # Define a system path.
    sys_path <- normalizePath(paste0(path, "/.data.library"), mustWork = FALSE)

    # Create the directory if it doesn't exist.
    if(!dir.exists(path)) {
        test <- dir.create(path, showWarnings = FALSE, recursive = TRUE)
        if(!test){
            stop("Creation of path `", path, "` failed.")
        }
    }

    if(!dir.exists(sys_path)) {
        test <- dir.create(sys_path, showWarnings = FALSE, recursive = TRUE)
        if(!test){
            stop("Creation of sys_path `", sys_path, "` failed.")
        }
    }

    # Check var names on `d` are unique.
    if(any(duplicated(names(d)))) {
        stop("Duplicated variable names on `d`: ", paste(names(d)[duplicated(names(d))], collapse = ", "))
    }

    # Write the data.library spec file.
    info <- list(
        var_order = names(d),
        creation_date_time = Sys.time(),
        creation_date = Sys.Date(),
        creation_path = normalizePath(path),
        object_class = data_class,
        row.names = if(data_class == "data.frame"){ row_names } else { FALSE }
    )
    saveRDS(info, paste0(sys_path, "/data.library.spec.rds"))

    # Overall time recording.
    o_time_start <- Sys.time()

    # Output individual RDS objects.
    for(i in names(d)) {
        # Start time.
        time_start <- Sys.time()
        # Save *.rds (with an `rds_` prefix for grouping).
        saveRDS(
            object = d[, ..i], 
            file = normalizePath(paste0(path, "\\rds_", i, ".rds"), mustWork = FALSE)
        )
        # End time.
        time_end <- Sys.time()
        # And if `verbose`, print output.
        if(verbose) { 
            message(paste0("# `", i, "` outputted (time: ", 
                round(difftime(time_end, time_start, units = 'mins'), 2),
                 " minutes)."
            ))
            flush.console()
        }
    }

    if(verbose) {
        message(paste0("\n# Overall time taken: ", 
            round(difftime(Sys.time(), o_time_start, units = 'mins'), 2),
            " minutes."
        ))
    }
}
