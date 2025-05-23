## ----knitr_options, echo=FALSE, results="hide"------------------------------------------------------------------------
options(width = 120)
knitr::opts_chunk$set(results = "hold")

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
# library("dataverse")
# Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
# dataverse_search("Gary King")[c("name")]

## ---------------------------------------------------------------------------------------------------------------------
##                                                                name
## 1                         004_informal_food_retail_Nigeria_2018.tab
## 2              00592Belle-Stress-PaperData-Subject_King_ChildIs.PDF
## 3               00592Belle-Stress-PaperData-Subject_King_ChildO.PDF
## 4               00592Belle-Stress-PaperData-Subject_King_Coping.PDF
## 5       00592Belle-Stress-PaperData-Subject_King_Discrimination.PDF
## 6               00592Belle-Stress-PaperData-Subject_King_LifeCs.PDF
## 7                00592Belle-Stress-PaperData-Subject_King_LifeE.PDF
## 8  00592Belle-Stress-PaperData-Subject_KingAndMeunier_Parenting.PDF
## 9                             00698McArthur-King-BoxCoverSheets.pdf
## 10                           00698McArthur-King-MemoOfAgreement.pdf

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
# dataverse_search("Gary King", start = 6, per_page = 20)[c("name")]

## ---------------------------------------------------------------------------------------------------------------------
# 10 of 3676 results retrieved
##                                                                                                                   name
## 1                                                                            004_informal_food_retail_Nigeria_2018.tab
## 2                                                                                00698McArthur-King-BoxCoverSheets.pdf
## 3                                                                               00698McArthur-King-MemoOfAgreement.pdf
## 4                                                                              00698McArthur-King-StudyDescription.pdf
## 5  01 ReadMe Unlocking history through automated virtual unfolding of sealed documents imaged by X-ray microtomography
## 6                                           01_ReadMe_The_Spiral_Locked_Letters_of_Elizabeth_I_and_Mary_Queen_of_Scots
## 7                                     03 Brienne Collection letterlocking data: Images folder 02/16, DB-0874_2–DB-0903
## 8                                    03 Brienne Collection letterlocking data: Images folder 04/16, DB-0988–DB-1109_03
## 9                                 03 Brienne Collection letterlocking data: Images folder 06/16, DB-1241_02–DB-1339_06
## 10                                03 Brienne Collection letterlocking data: Images folder 08/16, DB-1455_02–DB-1564_01

## ----eval=FALSE-------------------------------------------------------------------------------------------------------
# ei <- dataverse_search(author = "Gary King", title = "Ecological Inference", type = "dataset", per_page = 20)
# # fields returned
# names(ei)
# # names of datasets
# ei$name

## ---------------------------------------------------------------------------------------------------------------------
##  [1] "name"                    "type"                    "url"                     "global_id"              
##  [5] "description"             "published_at"            "publisher"               "citationHtml"           
##  [9] "identifier_of_dataverse" "name_of_dataverse"       "citation"                "storageIdentifier"      
## [13] "keywords"                "subjects"                "fileCount"               "versionId"              
## [17] "versionState"            "majorVersion"            "minorVersion"            "createdAt"              
## [21] "updatedAt"               "contacts"                "authors"                 "publications"           
##  [1] "01 ReadMe Unlocking history through automated virtual unfolding of sealed documents imaged by X-ray microtomography"        
##  [2] "01_ReadMe_The_Spiral_Locked_Letters_of_Elizabeth_I_and_Mary_Queen_of_Scots"                                                 
##  [3] "03 Brienne Collection letterlocking data: Images folder 02/16, DB-0874_2–DB-0903"                                           
##  [4] "03 Brienne Collection letterlocking data: Images folder 04/16, DB-0988–DB-1109_03"                                          
##  [5] "03 Brienne Collection letterlocking data: Images folder 06/16, DB-1241_02–DB-1339_06"                                       
##  [6] "03 Brienne Collection letterlocking data: Images folder 08/16, DB-1455_02–DB-1564_01"                                       
##  [7] "03 Brienne Collection letterlocking data: Images folder 12/16, DB-1868–DB-1963_03"                                          
##  [8] "03 Brienne Collection letterlocking data: Images folder 14/16, DB-2064_01–2155_03"                                          
##  [9] "03 Spiral-lock figures"                                                                                                     
## [10] "07 Letterlocking Categories and Formats Chart"                                                                              
## [11] "10 Foldable: Launch Little Book of Locks (UH6089), with Categories and Formats Chart. Letterlocking Instructional Resources"
## [12] "10 Million International Dyadic Events"                                                                                     
## [13] "1479 data points of covid19 policy response times"                                                                          
## [14] "2016 Census of Population: ADA and DA Maps for Kings County Nova Scotia"                                                    
## [15] "3D Dust map from Green et al. (2015)"                                                                                       
## [16] "3D dust map from Green et al. (2017)"                                                                                       
## [17] "3D dust map from Green et al. (2019)"                                                                                       
## [18] "A 1D Lyman-alpha Profile Camera for Plasma Edge Neutral Studies  on the DIII-D Tokamak"                                     
## [19] "A Comparative Analysis of Brazil's Foreign Policy Drivers Towards the USA: Comment on Amorim Neto (2011)"                   
## [20] "A Critique of Dyadic Design"
## 16                                                             1998 Jewish Community Study of the Coachella Valley, California
## 17                                                                                               2002 State Legislative Survey
## 18                                                                          2007 White Sands Dune Field lidar topographic data
## 19                                                                          2008 White Sands Dune Field lidar topographic data
## 20                                                                                                         2012 STATA Data.tab               


