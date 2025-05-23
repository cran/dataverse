#' @rdname files
#'
#' @title Download Dataverse file as a raw binary
#'
#' @description Download Dataverse File(s). `get_file_*`
#' functions return a raw binary file, which cannot be readily analyzed in R.
#' To use the objects as dataframes, see the `get_dataframe_*` functions at
#' `?get_dataframe` instead.
#'
#' @details This function provides access to data files from a Dataverse entry.
#' `get_file` is a general wrapper,
#'  and can take either dataverse objects, file IDs, or a filename and dataverse.
#'  Internally, all functions download each file by `get_file_by_id`.
#' `get_file_by_name` is a shorthand for running `get_file` by
#' specifying a file name (`filename`) and dataset (`dataset`).
#' `get_file_by_doi` obtains a file by its file DOI, bypassing the
#' `dataset` argument.
#'
#' @param file An integer specifying a file identifier; or a vector of integers
#' specifying file identifiers; or, if used with the prefix \code{"doi:"}, a
#' character with the file-specific DOI; or, if used without the prefix, a
#' filename accompanied by a dataset DOI in the `dataset` argument, or an object of
#' class \dQuote{dataverse_file} as returned by \code{\link{dataset_files}}.
#' Can be a vector for multiple files.
#' @param format A character string specifying a file format for download.
#' by default, this is \dQuote{original} (the original file format). If `NULL`,
#' no query is added, so ingested files are returned in their ingested TSV form.
#' For tabular datasets, the option \dQuote{bundle} downloads the bundle
#' of the original and archival versions, as well as the documentation.
#' See <https://guides.dataverse.org/en/latest/api/dataaccess.html> for details.
#' @param vars A character vector specifying one or more variable names, used to
#' extract a subset of the data.
#'
#' @template envvars
#' @template dots
#' @template ds
#' @template version
#'
#' @return \code{get_file} returns a raw vector (or list of raw vectors,
#' if \code{length(file) > 1}), which can be saved locally with the `writeBin`
#' function.  To load datasets into the R environment dataframe, see
#' \link{get_dataframe_by_name}.
#'
#' @seealso To load the objects as datasets \link{get_dataframe_by_name}.
#'
#' @examples
#' \dontrun{
#'
#' # 1. Using filename and dataverse
#' f1 <- get_file_by_name(
#'   filename = "nlsw88.tab",
#'   dataset  = "10.70122/FK2/PPIAXE",
#'   server   = "demo.dataverse.org"
#' )
#'
#' # 2. Using file DOI
#' f2 <- get_file_by_doi(
#'   filedoi  = "10.70122/FK2/PPIAXE/MHDB0O",
#'   server   = "demo.dataverse.org"
#' )
#'
#' # 3. Two-steps: Find ID from get_dataset
#' d3 <- get_dataset("doi:10.70122/FK2/PPIAXE", server = "demo.dataverse.org")
#' f3 <- get_file(d3$files$id[1], server = "demo.dataverse.org")
#'
#' # 4. Retrieve multiple raw data in list
#' f4_meta <- get_dataset(
#'   "doi:10.70122/FK2/PPIAXE",
#'   server = "demo.dataverse.org"
#' )
#'
#' f4 <- get_file(f4_meta$files$id, server = "demo.dataverse.org")
#' names(f4) <- f4_meta$files$label
#'
#' # Write binary files. To load into R environment, use get_dataframe_by_name()
#' # The appropriate file extension needs to be assigned by the user.
#'
#' writeBin(f1, "nlsw88.dta") # .tab extension but save as dta
#' writeBin(f4[["nlsw88_rds-export.rds"]], "nlsw88.rds") # originally a rds file
#' writeBin(f4[["nlsw88.tab"]], "nlsw88.dta") # originally a dta file
#' }
#'
#' @export
get_file <- function(
  file,
  dataset       = NULL,
  format        = c("original", "bundle"),
  vars          = NULL,
  return_url    = FALSE,
  key           = Sys.getenv("DATAVERSE_KEY"),
  server        = Sys.getenv("DATAVERSE_SERVER"),
  original      = TRUE,
  version       = ":latest",
  ...
) {

    format <- match.arg(format)

    # single file ID
    if (is.numeric(file))
      fileid <- file

    # get file ID from 'dataset'. Streamline in feature relying on get_fileid
    if (!is.numeric(file) & inherits(file, "dataverse_file"))
      fileid <- get_fileid.dataverse_file(file, key = key, server = server)

    if (!is.numeric(file) & !inherits(file, "dataverse_file") & !is.null(dataset))
      fileid <- get_fileid.character(dataset, file, key = key, server = server, ...)

    if (!is.numeric(file) & !inherits(file, "dataverse_file") & is.null(dataset)) {
      if (grepl(x = file, pattern = "^doi")) {
        fileid <- file # doi is allowed
      } else {
        stop("When 'file' is a character (non-global ID), dataset must be specified.")
      }
    }

    # Main function. Call get_file_by_id
    out <- vector("list", length(fileid))

    for (i in seq_along(fileid)) {
      out[[i]] <- get_file_by_id(
        fileid      = fileid[i],
        dataset     = dataset,
        format      = format,
        vars        = vars,
        key         = key,
        server      = server,
        original    = original,
        return_url  = return_url,
        ...
      )
    }

    if (length(out) == 1L) {    # return the raw vector if there's a single file
      return(out[[1]])
    } else {
      return(out) # return a list of raw vectors otherwise
    }
  }


#' @rdname files
#'
#' @param filename Filename of the dataset, with file extension as shown in Dataverse
#' (for example, if nlsw88.dta was the original but is displayed as the ingested
#' nlsw88.tab, use the ingested version.)
#'
#' @export
get_file_by_name <- function(
  filename,
  dataset,
  format        = c("original", "bundle"),
  vars          = NULL,
  return_url    = FALSE,
  key           = Sys.getenv("DATAVERSE_KEY"),
  server        = Sys.getenv("DATAVERSE_SERVER"),
  original      = TRUE,
  ...
) {
  format <- match.arg(format)


  # retrieve ID
  fileid <- get_fileid.character(
    x       = dataset,
    file    = filename,
    server  = server,
    ...
  )

  get_file_by_id(
    fileid,
    format      = format,
    vars        = vars,
    key         = key,
    server      = server,
    original    = original,
    return_url  = return_url,
    ...
  )
}
