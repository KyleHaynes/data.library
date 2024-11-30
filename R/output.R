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
output <- function(d, path, verbose = TRUE, ...) {

    # Normalise the path.
    path <- normalizePath(path, mustWork = FALSE)

    # Create the directory if it doesn't exist.
    if(!dir.exists(path)) {
        test <- dir.create(path, showWarnings = FALSE, recursive = TRUE)
        if(!test){
            stop("Creation of path `", path, "` failed.")
        }
    }

    # Check var names on `d` are unique.
    if(any(duplicated(names(d)))) {
        stop("Duplicated variable names on `d`: ", paste(names(d)[duplicated(names(d))], collapse = ", "))
    }

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
