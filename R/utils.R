# dataverse_id method
dataverse_id <- function(x, ...) {
  UseMethod('dataverse_id', x)
}
dataverse_id.default <- function(x, ...) {
  x
}
#' @export
dataverse_id.character <- function(x, ...) {
  get_dataverse(x, ..., check = FALSE)$id
}
#' @export
dataverse_id.dataverse <- function(x, ...) {
  x$id
}

# dataset_id method
dataset_id <- function(x, ...) {
  UseMethod("dataset_id", x)
}
#' @export
dataset_id.default <- function(x, ...) {
  x
}
#' @export
dataset_id.character <- function(x, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
  x <- prepend_doi(x)
  u <- paste0(api_url(server), "datasets/:persistentId?persistentId=", x)
  r <- tryCatch({
    api_get(u, ..., key = key)
  }, error = function(e) {
    stop(
      "Could not retrieve Dataset ID from persistent identifier! ",
      conditionMessage(e)
    )
  })
  jsonlite::fromJSON(r)[["data"]][["id"]]
}
#' @export
dataset_id.dataverse_dataset <- function(x, ...) {
  x$id
}

# get fileid from a dataset DOI or dataset ID
get_fileid <- function(x, ...) {
  UseMethod("get_fileid", x)
}

#' @export
get_fileid.numeric <- function(x, file, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
  files <- dataset_files(x, key = key, server = server, ...)
  ids <- unlist(lapply(files, function(x) x[["datafile"]][["id"]]))
  if (is.numeric(file)) {
    w <- which(ids %in% file)
    if (!length(w)) {
      stop("File not found")
    }
    id <- ids[w]
  } else {
    ns <- unlist(lapply(files, `[[`, "label"))
    w <- which(ns %in% file)
    if (!length(w)) {
      stop("File not found")
    }
    id <- ids[w]
  }
  id
}

#' @export
get_fileid.character <- function(x, file, key = Sys.getenv("DATAVERSE_KEY"), server = Sys.getenv("DATAVERSE_SERVER"), ...) {
  files <- dataset_files(prepend_doi(x), key = key, server = server, ...)
  ids <- unlist(lapply(files, function(x) x[["dataFile"]][["id"]]))
  if (is.numeric(file)) {
    w <- which(ids %in% file)
    if (!length(w)) {
      stop("File not found")
    }
    id <- ids[w]
  } else {
    ns <- unlist(lapply(files, `[[`, "label"))
    w <- which(ns %in% file)
    if (!length(w)) {
      stop("File not found")
    }
    id <- ids[w]
  }
  id
}

#' @export
get_fileid.dataverse_file <- function(x, ...) {
  x[["dataFile"]][["id"]]
}


# Ingested
#' Identify if file is an ingested file
#'
#' @param x A numeric fileid or file-specific DOI
#' @param ... Arguments passed on to `get_file` (no effect here)
#' @template envvars
#' @return Length-1 logical, `TRUE` if it is ingested and `FALSE` otherwise
#' @examples
#' \dontrun{
#' # https://demo.dataverse.org/file.xhtml?persistentId=doi:10.70122/FK2/PPIAXE
#' # nlsw88.tab
#' is_ingested(x = "doi:10.70122/FK2/PPIAXE/MHDB0O",
#'             server = "demo.dataverse.org")
#' is_ingested(x = 1734017,
#'             server = "demo.dataverse.org")
#'
#' # nlsw88_rds-export.rds
#' is_ingested(x = "doi:10.70122/FK2/PPIAXE/SUCFNI",
#'             server = "demo.dataverse.org")
#' is_ingested(x = 1734016,
#'             server = "demo.dataverse.org")
#'}
is_ingested <- function(
  x,
  key = Sys.getenv("DATAVERSE_KEY"),
  server  = Sys.getenv("DATAVERSE_SERVER"),
  ...) {

  is_number <- is.numeric(x)

  if (is_number) {
    file_info <- suppressMessages(dataverse_search(entityId = x, type = "file", server = server, key = key))
  } else {
    # expect doi
    x_query <- paste0("\"", x, "\"")
    file_info <- suppressMessages(dataverse_search(filePersistentId = x_query, type = "file", server = server, key = key))
  }

  if (length(file_info) == 0) {
    stop("File information not found on Dataverse API")
  }
  if (nrow(file_info) > 1)
    warning("More than 1 file found for `is_ingested`, search may be unreliable.")

  # if UNF (https://guides.dataverse.org/en/latest/developers/unf/index.html) is not null, it is ingested
  return(!is.null(file_info$unf[1]) && !is.na(file_info$unf[1]))
}


#' Get File size of file
#'
#' @param x A numeric fileid or file-specific DOI
#' @template envvars
#' @return number of bytes as a numeric
#' @keywords internal
get_filesize <- function(
  x,
  key = Sys.getenv("DATAVERSE_KEY"),
  server  = Sys.getenv("DATAVERSE_SERVER")) {

    is_number <- is.numeric(x)

    if (is_number) {
      file_info <- suppressMessages(dataverse_search(entityId = x, type = "file", server = server, key = key))
    } else {
      # expect doi
      x_query <- paste0("\"", x, "\"")
      file_info <- suppressMessages(dataverse_search(filePersistentId = x_query, type = "file", server = server, key = key))
    }

    if (length(file_info) == 0) {
      stop("File information not found on Dataverse API")
    }
    if (nrow(file_info) > 1)
      warning("More than 1 file found for `is_ingested`, search may be unreliable.")

    return(file_info$size_in_bytes)
}

# other functions
prepend_doi <- function(dataset) {
  if (grepl("^hdl", dataset)) {
    dataset <- dataset
  } else if (grepl("^doi:", dataset)) {
    dataset <- dataset
  } else if (grepl("^DOI:", dataset)) {
    dataset <- paste0("doi:", strsplit(dataset, "DOI:", fixed = TRUE)[[1]][2])
  } else if (!grepl("^doi:", dataset)) {
    if (grepl("dx\\.doi\\.org", dataset) | grepl("^http", dataset)) {
      dataset <- httr::parse_url(dataset)$path
    }
    dataset <- paste0("doi:", dataset)
  } else {
    dataset <- dataset
  }
  dataset
}

api_url <- function(server = Sys.getenv("DATAVERSE_SERVER"), prefix = "api/") {
  if (is.null(server) || server == "") {
    stop("'server' is missing with no default set in DATAVERSE_SERVER environment variable.")
  }
  server_parsed <- httr::parse_url(server)
  if (is.null(server_parsed[["hostname"]]) || server_parsed[["hostname"]] == "") {
    server_parsed[["hostname"]] <- server
  }
  if (is.null(server_parsed[["port"]]) || server_parsed[["port"]] == "") {
    domain <- server_parsed[["hostname"]]
  } else {
    domain <- paste0(server_parsed[["hostname"]], ":", server_parsed[["port"]])
  }
  return(paste0("https://", domain, "/", prefix))
}

## common httr::GET() uses
#' @importFrom checkmate assert_string
api_get <- function(url, ..., key = NULL, as = "text", use_cache = Sys.getenv("DATAVERSE_USE_CACHE", "session")) {
  assert_string(url)
  assert_string(key, null.ok = TRUE)
  assert_string(as, null.ok = TRUE)
  assert_use_cache(use_cache)
  get <- switch(
    use_cache,
    "none" = api_get_impl,
    "session" = api_get_session_cache,
    "disk" = api_get_disk_cache,
    stop("unknown value for 'use_cache'")
  )
  get(url, ..., key = key, as = as)
}

## cache implemented via memoization; memoized functions defined in
## .onLoad()
api_get_impl <- function(url, ..., key = NULL, as = "text") {
  if (!is.null(key))
    key <- httr::add_headers("X-Dataverse-key", key)
  r <- httr::GET(url, ..., key)
  httr::stop_for_status(r, task = httr::content(r)$message)
  httr::content(r, as = as, encoding = "UTF-8")
}

api_get_session_cache <- NULL      # per-session memoisatoin

api_get_disk_cache <- NULL # 'permanent' memoisation

# parse dataset response into list/dataframe
parse_dataset <- function(out) {
  out <- jsonlite::fromJSON(out)$data
  if ("latestVersion" %in% names(out)) {
    class(out$latestVersion) <- "dataverse_dataset_version"
  }
  if ("metadataBlocks" %in% names(out) && "citation" %in% out$metadata) {
    class(out$metadata$citation) <- "dataverse_dataset_citation"
  }
  # cleanup response
  file_df <- try(out$files$dataFile, silent = TRUE)
  if (inherits(file_df, "try-error") || is.null(file_df)) {
    file_df <- try(out$files$datafile, silent = TRUE)
    out$files$datafile <- NULL
  } else {
    out$files$dataFile <- NULL
  }

  # remove duplicate column
  if ("description" %in% colnames(file_df) & "description" %in% colnames(out$files)) {
    out$files[["description"]] <- NULL
  }

  out$files <- cbind(out$files, file_df)
  structure(out, class = "dataverse_dataset")
}

