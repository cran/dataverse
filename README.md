R Client for Dataverse Repositories
================

[![CRAN
Version](https://www.r-pkg.org/badges/version/dataverse)](https://cran.r-project.org/package=dataverse)
![Downloads](https://cranlogs.r-pkg.org/badges/dataverse)

[![R-CMD-check-thorough](https://github.com/IQSS/dataverse-client-r/actions/workflows/R-CMD-check-thorough.yaml/badge.svg?branch=main)](https://github.com/IQSS/dataverse-client-r/actions/workflows/R-CMD-check-thorough.yaml)
[![R-CMD-check-daily](https://github.com/IQSS/dataverse-client-r/actions/workflows/R-CMD-check-daily.yaml/badge.svg?branch=main)](https://github.com/IQSS/dataverse-client-r/actions/workflows/R-CMD-check-daily.yaml)
[![R-CMD-check-dev](https://github.com/IQSS/dataverse-client-r/actions/workflows/R-CMD-check-dev.yaml/badge.svg)](https://github.com/IQSS/dataverse-client-r/actions/workflows/R-CMD-check-dev.yaml)
[![codecov.io](https://codecov.io/github/IQSS/dataverse-client-r/coverage.svg?branch=main)](https://app.codecov.io/github/IQSS/dataverse-client-r?branch=main)

[![Dataverse Project
logo](https://dataverse.org/files/dataverseorg/files/dataverse_project_logo-hp.png)](https://dataverse.org)

The **dataverse** package provides access to
[Dataverse](https://dataverse.org/) APIs (versions 4+), enabling data
search, retrieval, and deposit, thus allowing R users to integrate
public data sharing into the reproducible research workflow.

### Getting Started

You can find a stable release on
[CRAN](https://cran.r-project.org/package=dataverse), or install the
latest development version from
[GitHub](https://github.com/iqss/dataverse-client-r/):

``` r
# Install from CRAN
install.packages("dataverse")

# Install from GitHub
# install.packages("remotes")
remotes::install_github("iqss/dataverse-client-r")
```

#### API Access Keys

Many features of the Dataverse API are public and require no
authentication. This means in many cases you can search for and retrieve
data without a Dataverse account or API key – you will not need to worry
about this.

For features that require a Dataverse account for the specific server
installation of the Dataverse software, and an API key linked to that
account. Instructions for obtaining an account and setting up an API key
are available in the [Dataverse User
Guide](https://guides.dataverse.org/en/latest/user/account.html). (Note:
if your key is compromised, it can be regenerated to preserve security.)
Once you have an API key, this should be stored as an environment
variable called `DATAVERSE_KEY`. It can be set as a default by adding

``` r
DATAVERSE_KEY="examplekey12345"
```

in your .Renviron file, where `examplekey12345` should be replaced with
your own key. The environment file can be opened by
`usethis::edit_r_environ()`.

#### Server

Because [there are many Dataverse
installations](https://dataverse.org/), all functions in the R client
require specifying what server installation you are interacting with.
There are multiple ways to specify the server:

1.  Set the `server` argument in each function. e.g.,
    `server = "dataverse.harvard.edu"` in the `get_dataframe_by_name()`
    function.

2.  Set the environment variable, `DATAVERSE_SERVER`, in the script to
    be used throughout the session. e.g.,

``` r
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
```

3.  Hard-code a default server in your own environment. Direct your
    `.Renviron` file directly or open it by `usethis::edit_r_environ()`.
    Then enter `DATAVERSE_SERVER = "dataverse.harvard.edu"`. However,
    doing this may make your scripts not replicable to other people who
    do not have access to the environment.

In all cases, values should be the Dataverse server, without the “https”
prefix or the “/api” URL path.

### Data Download

The dataverse package provides multiple interfaces to obtain data into
R. Users can supply a file DOI, a dataset DOI combined with a filename,
or a dataverse object. They can read in the file as a raw binary or a
dataset read in with the appropriate R function.

#### Reading data as R objects

Use the `get_dataframe_*()` functions, depending on the input you have.
For example, we will read a survey dataset on Dataverse,
[nlsw88.dta](https://demo.dataverse.org/dataset.xhtml?persistentId=doi:10.70122/FK2/PPIAXE)
(`doi:10.70122/FK2/PPKHI1/ZYATZZ`), originally in Stata dta form.

With a file DOI, we can use the `get_dataframe_by_doi` function:

``` r
nlsw <-
  get_dataframe_by_doi(
    filedoi     = "10.70122/FK2/PPIAXE/MHDB0O",
    server      = "demo.dataverse.org"
  )
```

    ## Downloading ingested version of data with readr::read_tsv. To download the original version and remove this message, set original = TRUE.

    ## Rows: 2246 Columns: 17
    ## ── Column specification ────────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: "\t"
    ## dbl (17): idcode, age, race, married, never_married, grade, collgrad, south, smsa, c_city, industry, occupation, uni...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

which by default reads in the ingested file (not the original dta) by
the
[`readr::read_tsv`](https://readr.tidyverse.org/reference/read_delim.html)
function.

Alternatively, we can download the same file by specifying the filename
and the DOI of the “dataset” (in Dataverse, a collection of files is
called a dataset).

``` r
nlsw_tsv <-
  get_dataframe_by_name(
    filename  = "nlsw88.tab",
    dataset   = "10.70122/FK2/PPIAXE",
    server    = "demo.dataverse.org"
  )
```

**The `original` argument:** Dataverse often translates rectangular data
into an ingested, or “archival” version, which is application-neutral
and easily-readable. `read_dataframe_*()` defaults to taking this
ingested version rather than using the original, through the argument
`original = FALSE`. This default is safe because you may not have the
proprietary software that was originally used.

On the other hand, the data may have lost information in the process of
the ingestion. Instead, to read the same file but its original version,
specify `original = TRUE` and set an `.f` argument. In this case, we
know that `nlsw88.tab` is a Stata `.dta` dataset, so we will use the
`haven::read_dta` function.

``` r
nlsw_original <-
  get_dataframe_by_name(
    filename    = "nlsw88.tab",
    dataset     = "10.70122/FK2/PPIAXE",
    .f          = haven::read_dta,
    original    = TRUE,
    server      = "demo.dataverse.org"
  )
```

Note that even though the file prefix is “.tab”, we use
`haven::read_dta`.

Of course, when the dataset is not ingested (such as a Rds file), users
would always need to specify an `.f` argument for the specific file.

Note the difference between `nls_tsv` and `nls_original`. `nls_original`
preserves the data attributes like value labels, whereas `nls_tsv` has
dropped this or left this in file metadata.

``` r
class(nlsw_tsv$race) # tab ingested version only has numeric data
```

    ## [1] "numeric"

``` r
attr(nlsw_original$race, "labels") # original dta has value labels
```

    ## white black other 
    ##     1     2     3

**Caching**: When the dataset to be downloaded is large, downloading the
dataset from the internet can be time consuming, and users want to run
the download only once in a script they run multiple times. As of
version 0.3.15, our package will cache the download data if the user
specifies which version of the Dataverse dataset they download from. See
the `version` argument in the help page.

### Data Upload and Archiving

**Note**: *There are known issues to using to dataverse creation and
dataset addition functionalities listed here. `add_dataset_file()`
appears stable as of again as of v0.3.11. One possible workaround is to
mix the two workflows described above (See e.g. this
[comment](https://github.com/IQSS/dataverse-client-r/issues/82#issuecomment-1094623268)).*

Dataverse provides two - basically unrelated - workflows for managing
(adding, documenting, and publishing) datasets. The first workflow is
called the “native” API and uses `create_dataset` to make an empty
dataset and adds files by `add_dataset_file` by taking a path to a
dataset that is located in your local. Through the native API it is
possible to update a dataset by modifying its metadata with
`update_dataset()` or file contents using `update_dataset_file()` and
then republish a new version using `publish_dataset()`.

``` r
# create the dataset. e/g/ 
ds <- create_dataset("mydataverse") # pick a name of dataset

# add files
tmp <- tempfile() # In this example, we write to a temporary destiation
write.csv(iris, file = tmp)
add_dataset_file(file = tmp, dataset = ds)

# publish dataset
publish_dataset(ds)

# dataset will now be published
get_dataverse("mydataverse")
```

The second is built on [SWORD](https://sword.cottagelabs.com/) (v2.0).
This means that to create a new dataset listing, you will have to first
initialize a dataset entry with some metadata, add one or more files to
the dataset, and then publish it. This looks something like the
following:

``` r
# After setting appropriate dataverse server and environment, obtain SWORD
# service doc
d <- service_document()

# create a list of metadata for a file
metadat <-
  list(
    title       = paste0("My-Study_", format(Sys.time(), '%Y-%m-%d_%H:%M')),
    creator     = "Doe, John",
    description = "An example study"
  )

# create the dataset, where "mydataverse" is to be replaced by the name 
# of the already-created dataverse as shown in the URL
ds <- initiate_sword_dataset("<mydataverse>", body = metadat)

# add files to dataset
readr::write_csv(iris, file = "iris.csv")

# Search the initiated dataset and give a DOI and version of the dataverse as an identifier
mydoi <- "doi:10.70122/FK2/BMZPJZ&version=DRAFT"

# add dataset
add_dataset_file(file = "iris.csv", dataset = mydoi)

# publish new dataset
publish_sword_dataset(ds)

# dataset will now be published
list_datasets("<mydataverse>")
```

### Limitations

The R client is current stable for data search and download. For more
extensive features of *uploading* and maintaining data, see the issues
reported in the Github repository. You may need to use alternative
methods, such as working on the Dataverse GUI directly or using
[pyDataverse](https://pydataverse.readthedocs.io/en/latest/).

Functions related to user management and permissions are currently not
exported in the package (but are drafted in the source code).

### Related Software

**dataverse** is the next-generation iteration of the now removed
**dvn** package, which works with Dataverse 3 (“Dataverse Network”)
applications.

Dataverse clients in other programming languages include
[pyDataverse](https://pydataverse.readthedocs.io/en/latest/) for Python
and the [Java client](https://github.com/IQSS/dataverse-client-java).
For more information, see [the Dataverse API
page](https://guides.dataverse.org/en/5.5/api/client-libraries.html#r).

Users interested in downloading metadata from archives other than
Dataverse may be interested in Kurt Hornik’s
[OAIHarvester](https://cran.r-project.org/package=OAIHarvester) and
Scott Chamberlain’s [oai](https://cran.r-project.org/package=oai), which
offer metadata download from any web repository that is compliant with
the [Open Archives Initiative](https://www.openarchives.org:443/)
standards. Additionally,
[rdryad](https://cran.r-project.org/package=rdryad) uses OAIHarvester to
interface with [Dryad](https://datadryad.org/). The
[rfigshare](https://cran.r-project.org/package=rfigshare) package works
in a similar spirit to **dataverse** with <https://figshare.com/>.

### More Information

A 2021 talk demonstrating the Dataverse package is available at
<https://www.youtube.com/watch?v=-J-eiPnmoNE>.
