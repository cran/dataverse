% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataverse_metadata.R
\name{set_dataverse_metadata}
\alias{set_dataverse_metadata}
\title{Set Dataverse metadata}
\usage{
set_dataverse_metadata(
  dataverse,
  body,
  root = TRUE,
  key = Sys.getenv("DATAVERSE_KEY"),
  server = Sys.getenv("DATAVERSE_SERVER"),
  ...
)
}
\arguments{
\item{dataverse}{A character string specifying a Dataverse name or an object of class \dQuote{dataverse}.}

\item{body}{A list.}

\item{root}{A logical.}

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

\item{...}{Additional arguments passed to an HTTP request function,
such as \code{\link[httr]{GET}}, \code{\link[httr]{POST}}, or
\code{\link[httr]{DELETE}}. See \code{\link{use_cache}} for details
on how the \emph{R} dataverse package uses disk and session caches to
improve network performance.}
}
\value{
A list
}
\description{
Set Dataverse metadata
}
\details{
This function sets the value of metadata fields for a Dataverse. Use \code{\link{update_dataset}} to set the metadata fields for a dataset instead.
}
\seealso{
\code{\link{dataverse_metadata}}
}
