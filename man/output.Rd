% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/output.R
\name{output}
\alias{output}
\title{Output data}
\usage{
output(
  d,
  path = getOption("data.library.path"),
  metadata = NA,
  verbose = TRUE,
  ...
)
}
\arguments{
\item{d}{data.table, data.frame or tibble to export.}

\item{path}{Folder path of where the data will be output.}

\item{verbose}{Logical argument to be verbose.}
}
\description{
Output data to *.RDS objects.
}
