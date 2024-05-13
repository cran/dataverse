## ----knitr_options, echo=FALSE, results="hide"------------------------------------------------------------------------
options(width = 120)
knitr::opts_chunk$set(results = "hold")

## ---------------------------------------------------------------------------------------------------------------------
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")

## ---------------------------------------------------------------------------------------------------------------------
library("dataverse")
library("tibble") # to see dataframes in tidyverse-form

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  energy <- get_dataframe_by_name(
#    filename = "comprehensiveJapanEnergy.tab",
#    dataset = "10.7910/DVN/ARKOTI",
#    server = "dataverse.harvard.edu")

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  head(energy)

## ---------------------------------------------------------------------------------------------------------------------
## # A tibble: 6 × 10
##    time date  dummy  temp temp2      all    large    house    kepco    tepco
##   <dbl> <chr> <dbl> <dbl> <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
## 1     1 8-Jan     0   5.9  34.8 95792389 35194957 26190714 13357735 26960899
## 2     2 8-Feb     0   5.5  30.3 95156901 35322031 24224097 13315027 27189705
## 3     3 8-Mar     0  10.7 114.  91034047 36474192 21391965 12805831 24495519
## 4     4 8-Apr     0  14.7 216.  84087552 34949622 18494473 11494328 23540356
## 5     5 8-May     0  18.5 342.  82742929 35417089 17923760 11589061 22848737
## 6     6 8-Jun     0  21.3 454.  82180013 36692291 15205229 11360771 22487441

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  library(readr)
#  energy <- get_dataframe_by_name(
#    filename = "comprehensiveJapanEnergy.tab",
#    dataset = "10.7910/DVN/ARKOTI",
#    server = "dataverse.harvard.edu",
#    .f = function(x) read.delim(x, sep = "\t"))
#  
#  head(energy)

## ---------------------------------------------------------------------------------------------------------------------
##   time  date dummy temp temp2      all    large    house    kepco    tepco
## 1    1 8-Jan     0  5.9  34.8 95792389 35194957 26190714 13357735 26960899
## 2    2 8-Feb     0  5.5  30.3 95156901 35322031 24224097 13315027 27189705
## 3    3 8-Mar     0 10.7 114.5 91034047 36474192 21391965 12805831 24495519
## 4    4 8-Apr     0 14.7 216.1 84087552 34949622 18494473 11494328 23540356
## 5    5 8-May     0 18.5 342.3 82742929 35417089 17923760 11589061 22848737
## 6    6 8-Jun     0 21.3 453.7 82180013 36692291 15205229 11360771 22487441

## ----message=FALSE,eval=FALSE-----------------------------------------------------------------------------------------
#  argentina_tab <- get_dataframe_by_name(
#    filename = "alpl2013.tab",
#    dataset = "10.7910/DVN/ARKOTI",
#    server = "dataverse.harvard.edu")

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  str(argentina_tab$polling_place)

## ---------------------------------------------------------------------------------------------------------------------
## num [1:1475] 31 31 31 31 31 31 31 31 31 31 ...

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  argentina_dta <- get_dataframe_by_name(
#    filename = "alpl2013.tab",
#    dataset = "10.7910/DVN/ARKOTI",
#    server = "dataverse.harvard.edu",
#    original = TRUE,
#    .f = haven::read_dta)

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  str(argentina_dta$polling_place)

## ---------------------------------------------------------------------------------------------------------------------
##  dbl+lbl [1:1475] 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3...
##  @ label       : chr "polling_place"
##  @ format.stata: chr "%9.0g"
##  @ labels      : Named num [1:37] 1 2 3 4 5 6 7 8 9 10 ...
##   ..- attr(*, "names")= chr [1:37] "E.E.T." "Escuela Juan Bautista Alberdi" "Escuela Juan Carlos DÃ¡valos" "Escuela Bernardino de Rivadavia" ...

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
#  str(dataset_metadata("10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu"),
#      max.level = 2)

## ---------------------------------------------------------------------------------------------------------------------
## List of 3
##  $ displayName: chr "Citation Metadata"
##  $ name       : chr "citation"
##  $ fields     :'data.frame': 7 obs. of  4 variables:
##   ..$ typeName : chr [1:7] "title" "author" "datasetContact" "dsDescription" ...
##   ..$ multiple : logi [1:7] FALSE TRUE TRUE TRUE TRUE FALSE ...
##   ..$ typeClass: chr [1:7] "primitive" "compound" "compound" "compound" ...
##   ..$ value    :List of 7

## ----eval = FALSE-----------------------------------------------------------------------------------------------------
#  code3 <- get_file("chapter03.R", "doi:10.7910/DVN/ARKOTI", server = "dataverse.harvard.edu")
#  writeBin(code3, "chapter03.R")

