% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_dataverse.R
\name{get_dataverse}
\alias{get_dataverse}
\alias{dataverse_contents}
\title{Get Dataverse}
\usage{
get_dataverse(
  dataverse,
  key = Sys.getenv("DATAVERSE_KEY"),
  server = Sys.getenv("DATAVERSE_SERVER"),
  check = TRUE,
  ...
)

dataverse_contents(
  dataverse,
  key = Sys.getenv("DATAVERSE_KEY"),
  server = Sys.getenv("DATAVERSE_SERVER"),
  ...
)
}
\arguments{
\item{dataverse}{A character string specifying a Dataverse name or an object of class \dQuote{dataverse}.}

\item{key}{A character string specifying a Dataverse server API key. If one
is not specified, functions calling authenticated API endpoints will fail.
Keys can be specified atomically or globally using
\code{Sys.setenv("DATAVERSE_KEY" = "examplekey")}.}

\item{server}{A character string specifying a Dataverse server.
Multiple Dataverse installations exist, with \code{"dataverse.harvard.edu"} being the
most major. The server can be defined each time within a function, or it can
be set as a default via an environment variable. To set a default, run
\code{Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")}
or add \code{DATAVERSE_SERVER = "dataverse.harvard.edu"} in one's \code{.Renviron}
file (\code{usethis::edit_r_environ()}), with the appropriate domain as its value.}

\item{check}{A logical indicating whether to check that the value of \code{dataverse} is actually a numeric}

\item{...}{Additional arguments passed to an HTTP request function,
such as \code{\link[httr]{GET}}, \code{\link[httr]{POST}}, or
\code{\link[httr]{DELETE}}. See \code{\link{use_cache}} for details
on how the \emph{R} dataverse package uses disk and session caches to
improve network performance.}
}
\value{
A list of class \dQuote{dataverse}.
}
\description{
Retrieve details of a Dataverse
}
\details{
\code{get_dataverse} function retrieves basic information about a Dataverse from a Dataverse server. To see the contents of the Dataverse, use \code{\link{dataverse_contents}} instead. Contents might include one or more \dQuote{datasets} and/or further Dataverses that themselves contain Dataverses and/or datasets. To view the file contents of a single Dataset, use \code{\link{get_dataset}}.
}
\examples{
\dontrun{
# https://demo.dataverse.org/dataverse/dataverse-client-r
Sys.setenv("DATAVERSE_SERVER" = "demo.dataverse.org")

# download file from:
dv <- get_dataverse("dataverse-client-r")

# get a dataset from the dataverse
(d1 <- get_dataset(dataverse_contents(dv)[[1]]))

# download a file using the metadata
get_dataframe_by_name("roster-bulls-1996.tab", d1$datasetPersistentId)
}

}
