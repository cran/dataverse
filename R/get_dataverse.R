#' @rdname get_dataverse
#' @title Get Dataverse
#' @description Retrieve details of a Dataverse
#'
#' @details \code{get_dataverse} function retrieves basic information about a Dataverse from a Dataverse server. To see the contents of the Dataverse, use \code{\link{dataverse_contents}} instead. Contents might include one or more \dQuote{datasets} and/or further Dataverses that themselves contain Dataverses and/or datasets. To view the file contents of a single Dataset, use \code{\link{get_dataset}}.
#'
#' @template dv
#' @template envvars
#' @param check A logical indicating whether to check that the value of \code{dataverse} is actually a numeric
#' @template dots
#' @return A list of class \dQuote{dataverse}.
#'
#' @examples
#' \dontrun{
#' # https://demo.dataverse.org/dataverse/dataverse-client-r
#' Sys.setenv("DATAVERSE_SERVER" = "demo.dataverse.org")
#'
#' # download file from:
#' dv <- get_dataverse("dataverse-client-r")
#'
#' # get a dataset from the dataverse
#' (d1 <- get_dataset(dataverse_contents(dv)[[1]]))
#'
#' # download a file using the metadata
#' get_dataframe_by_name("roster-bulls-1996.tab", d1$datasetPersistentId)
#' }
#'
#' @export
get_dataverse <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), check = TRUE, ...) {
    if (isTRUE(check)) {
        dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
    }
    u <- paste0(api_url(server), "dataverses/", dataverse)
    r <- api_get(u, ..., key = key)
    out <- jsonlite::fromJSON(r)
    structure(out$data, class = "dataverse")
}

#' @rdname get_dataverse
#' @export
dataverse_contents <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    dataverse <- dataverse_id(dataverse, key = key, server = server, ...)
    u <- paste0(api_url(server), "dataverses/", dataverse, "/contents")
    r <- api_get(u, ..., key = key)
    out <- jsonlite::fromJSON(r, simplifyDataFrame = FALSE)
    structure(lapply(out$data, function(x) {
        `class<-`(x, if (x$type == "dataset") "dataverse_dataset" else "dataverse")
    }))
}
