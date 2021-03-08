## ----knitr_options, echo=FALSE, results="hide"------------------------------------------------------------------------
options(width = 120)
knitr::opts_chunk$set(results = "hold")

## ---------------------------------------------------------------------------------------------------------------------
library("dataverse")
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")

## ---------------------------------------------------------------------------------------------------------------------
str(dataset_metadata("10.7910/DVN/ARKOTI"), 2)

## ---- messages=FALSE--------------------------------------------------------------------------------------------------
energy <- get_dataframe_by_name(
  "comprehensiveJapanEnergy.tab",
  "10.7910/DVN/ARKOTI")

head(energy)

## ---------------------------------------------------------------------------------------------------------------------
library(readr)
energy <- get_dataframe_by_name(
  "comprehensiveJapanEnergy.tab",
  "10.7910/DVN/ARKOTI",
  .f = function(x) read.delim(x, sep = "\t"))

head(energy)

## ----  message=FALSE--------------------------------------------------------------------------------------------------
argentina_tab <- get_dataframe_by_name(
  "alpl2013.tab",
  "10.7910/DVN/ARKOTI")

## ---------------------------------------------------------------------------------------------------------------------
str(argentina_tab$polling_place)

## ---------------------------------------------------------------------------------------------------------------------
argentina_dta <- get_dataframe_by_name(
  "alpl2013.tab",
  "10.7910/DVN/ARKOTI",
  original = TRUE,
  .f = haven::read_dta)

## ---------------------------------------------------------------------------------------------------------------------
str(argentina_dta$polling_place)

## ---- eval = FALSE----------------------------------------------------------------------------------------------------
#  code3 <- get_file("chapter03.R", "doi:10.7910/DVN/ARKOTI")
#  writeBin(code3, "chapter03.R")

