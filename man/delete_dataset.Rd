% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/delete_dataset.R
\name{delete_dataset}
\alias{delete_dataset}
\title{Delete draft dataset}
\usage{
delete_dataset(
  dataset,
  key = Sys.getenv("DATAVERSE_KEY"),
  server = Sys.getenv("DATAVERSE_SERVER"),
  ...
)
}
\arguments{
\item{dataset}{A character specifying a persistent identification ID for a dataset,
for example \code{"doi:10.70122/FK2/HXJVJU"}. Alternatively, an object of class
\dQuote{dataverse_dataset} obtained by \code{dataverse_contents()}.}

\item{key}{A character string specifying a Dataverse server API key. If one
is not specified, functions calling authenticated API endpoints will fail.
Keys can be specified atomically or globally using
\code{Sys.setenv("DATAVERSE_KEY" = "examplekey")}.}

\item{server}{A character string specifying a Dataverse server. There are
multiple Dataverse installations, but the defaults is to use the Harvard
Dataverse (\code{server = "dataverse.harvard.edu"}). This can be modified atomically
or globally using \code{Sys.setenv("DATAVERSE_SERVER" = "dataverse.example.com")}.}

\item{...}{Additional arguments passed to an HTTP request function, such as
\code{\link[httr]{GET}}, \code{\link[httr]{POST}}, or
\code{\link[httr]{DELETE}}.}
}
\value{
A logical.
}
\description{
Delete a dataset draft
}
\details{
This function can be used to delete a draft (unpublished) Dataverse dataset. Once published, a dataset cannot be deleted. An existing draft can instead be modified using \code{\link{update_dataset}}.
}
\examples{
\dontrun{
meta <- list()
ds <- create_dataset("mydataverse", body = meta)
delete_dataset(ds)
}
}
\seealso{
\code{\link{get_dataset}}, \code{\link{create_dataset}}, \code{\link{update_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
}
