#' @title SWORD Service Document
#' @description Obtain a SWORD service document.
#' @details This function can be used to check authentication against the Dataverse SWORD server. It is typically a first step when creating a new Dataverse, a new Dataset, or modifying an existing Dataverse or Dataset.
#' @template envvars
#' @template dots
#' @return A list of class \dQuote{sword_service_document}, possibly with one or more \dQuote{sword_collection} entries. The latter are SWORD representations of a Dataverse. These can be passed to other SWORD API functions, e.g., for creating a new dataset.
#' @examples
#' \dontrun{
#' # retrieve your service document
#' d <- service_document()
#'
#' # list available datasets in first dataverse
#' list_datasets(d[[2]])
#' }
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#'
#' @export
service_document <- function(key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    u <- paste0(api_url(server, prefix = "dvn/api/"), "data-deposit/v1.1/swordv2/service-document")
    r <- api_get(u, httr::authenticate(key, ""), ...)
    x <- xml2::as_list(xml2::read_xml(r))
    w <- x$workspace
    out <- list()
    if ("title" %in% names(w)) {
        out$title <- w$title[[1]]
    }
    n <- which(names(w) == "collection")
    for (i in n) {
        s <- structure(list(name = w[[i]][[1]][[1]],
                            terms_of_use = w[[i]][[2]][[1]],
                            terms_apply = w[[i]][[3]][[1]],
                            package = w[[i]][[4]][[1]],
                            url = attributes(w[[i]])$href),
                       class = "dataverse")
        s$alias <- strsplit(s$url, "/collection/dataverse/")[[1]][2]
        out[[length(out) + 1]] <- s
    }
    out <- stats::setNames(out, `[<-`(names(out), n, "dataverse"))
    structure(out, class = "sword_service_document")
}

#' @export
print.sword_service_document <- function(x, ...) {
    cat("Title: ", x$title, "\n")
    for (i in which(names(x) == "dataverse")) {
        cat("[[", i, "]]\n", sep = "")
        print(x[[i]])
        cat("\n")
    }
    invisible(x)
}

#' @title List datasets (SWORD)
#' @description List datasets in a SWORD (possibly unpublished) Dataverse
#' @details This function is used to list datasets in a given Dataverse. It is part of the SWORD API, which is used to upload data to a Dataverse server. This means this can be used to view unpublished Dataverses and Datasets.
#' @param dataverse A Dataverse alias or ID number, or an object of class \dQuote{dataverse}, perhaps as returned by \code{\link{service_document}}.
#' @template envvars
#' @template dots
#' @return A list.
#' @examples
#' \dontrun{
#' Sys.setenv("DATAVERSE_SERVER" = "demo.dataverse.org")
#' Sys.setenv("DATAVERSE_KEY"    = "c7208dd2-6ec5-469a-bec5-f57e164888d4")
#' dv <- get_dataverse("dataverse-client-r")
#' list_datasets(dv)
#' }
#' @seealso Managing a Dataverse: \code{\link{publish_dataverse}}; Managing a dataset: \code{\link{dataset_atom}}, \code{\link{list_datasets}}, \code{\link{create_dataset}}, \code{\link{delete_dataset}}, \code{\link{publish_dataset}}; Managing files within a dataset: \code{\link{add_file}}, \code{\link{delete_file}}
#' @export
list_datasets <- function(dataverse, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
    if (inherits(dataverse, "dataverse")) {
        dataverse <- dataverse$alias
    } else if (is.numeric(dataverse)) {
        dataverse <- get_dataverse(dataverse, key = key, server = server, ...)$alias
    }
    u <- paste0(api_url(server, prefix = "dvn/api/"), "data-deposit/v1.1/swordv2/collection/dataverse/", dataverse)
    r <- api_get(u, httr::authenticate(key, ""), ..., as = "raw")

    # clean up response structure
    x <- xml2::as_list(xml2::read_xml(r))
    feed <- x[["feed"]]
    out <- list(title = feed[["title"]][[1L]],
                generator = feed[["generator"]],
                dataverseHasBeenReleased = feed[["dataverseHasBeenReleased"]][[1L]])
    out[["datasets"]] <- do.call("rbind.data.frame",
        lapply(feed[which(names(feed) == "entry")], function(ds) {
            list(title = ds[["title"]][[1L]],
                 id = ds[["id"]][[1L]])
        })
    )
    rownames(out[["datasets"]]) <- seq_len(nrow(out[["datasets"]]))
    structure(out, class = "dataverse_dataset_list")
}
