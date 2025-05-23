% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_dataset_file.R
\name{add_dataset_file}
\alias{add_dataset_file}
\alias{update_dataset_file}
\title{Add or update a file in a dataset}
\usage{
add_dataset_file(
  file,
  dataset,
  description = NULL,
  key = Sys.getenv("DATAVERSE_KEY"),
  server = Sys.getenv("DATAVERSE_SERVER"),
  ...
)

update_dataset_file(
  file,
  dataset = NULL,
  id,
  description = NULL,
  force = TRUE,
  key = Sys.getenv("DATAVERSE_KEY"),
  server = Sys.getenv("DATAVERSE_SERVER"),
  ...
)
}
\arguments{
\item{file}{A character string for the location path of the file to be uploaded.}

\item{dataset}{A character specifying a persistent identification ID for a dataset,
for example \code{"10.70122/FK2/HXJVJU"}. Alternatively, an object of class
\dQuote{dataverse_dataset} obtained by \code{dataverse_contents()}.}

\item{description}{Optionally, a character string providing a description of the file.}

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

\item{id}{An integer specifying a file identifier; or, if \code{doi} is specified,
a character string specifying a file name within the DOI-identified dataset; or an
object of class \dQuote{dataverse_file} as returned by \code{\link{dataset_files}}.}

\item{force}{A logical indicating whether to force the update even if the file
types differ. Default is \code{TRUE}.}
}
\value{
\code{add_dataset_file} returns the new file ID. It also uploads the file
to the dataset.
}
\description{
Add or update a file in a dataset. For most applications, this
is the recommended function to upload your own local datasets to an
existing Dataverse dataset. Uploading requires a Dataverse API Key in the \code{key}
variable.
}
\details{
From Dataverse v4.6.1, the \dQuote{native} API provides endpoints to add and
update files without going through the SWORD workflow. To use SWORD instead,
see \code{\link{add_file}}. \code{add_dataset_file} adds a new file to a specified dataset.

\code{update_dataset_file} can be used to replace/update a published file.
Note that it only works on published files, so unpublished drafts cannot be updated -
the dataset must first either be published (\code{\link{publish_dataset}}) or
deleted (\code{\link{delete_dataset}}).
}
\examples{
\dontrun{
meta <- list()
ds <- create_dataset("mydataverse", body = meta)


# Upload RDS dataset saved to local
saveRDS(mtcars, tmp <- tempfile(fileext = ".rds"))
f <- add_dataset_file(tmp, dataset = ds, description = "mtcars")

# Publish dataset
publish_dataset(ds)

# Update file and republish
saveRDS(iris, tmp)
update_dataset_file(tmp, dataset = ds, id = f,
                    description = "Actually iris")
publish_dataset(ds)

# Cleanup
unlink(tmp)
delete_dataset(ds)
}
}
\seealso{
\code{\link{get_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}
}
