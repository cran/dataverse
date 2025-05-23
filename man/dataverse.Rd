% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataverse-package.R
\docType{package}
\name{dataverse}
\alias{dataverse-package}
\alias{dataverse}
\title{Client for Dataverse Repositories}
\description{
Provides access to Dataverse 4+ APIs, enabling data search, retrieval, and deposit.
}
\details{
Dataverse is open-source data repository management software developed by the Institute for Quantitative Social Science at Harvard University. This package provides an R interface to Dataverse version 4 repositories, including the principal Dataverse hosted at Harvard (\url{https://dataverse.harvard.edu/}). Users can use the package to search for data stored in a Dataverse repository, retrieve data and other files, and also use the package to directly create and archive their own research data and software.

A Dataverse is structured as a nested set of \dQuote{dataverse} repositories, such that a single dataverse can contain \dQuote{datasets} (a set of code files, data files, etc.) or other dataverses. Thus, users may want to search for dataverses (sets of dataverses and datasets), datasets (sets of files), or individual files, and retrieve those objects accordingly. To retrieve a given file, a user typically needs to know what dataset it is stored in. All datasets are identified by a persistent identifier (such as an DOI or Handle, depending on the age of the dataset and what Dataverse repository it is hosted in).

This package provides five main sets of functions to interact with Dataverse:

\itemize{
\item Search: \code{\link{dataverse_search}}
\item Data download: \code{\link{get_dataframe_by_name}}, \code{\link{get_dataverse}}, \code{\link{dataverse_contents}}, \code{\link{get_dataset}}, \code{\link{dataset_metadata}}, \code{\link{get_file}}
\item Data archiving (SWORD API): \code{\link{service_document}}, \code{\link{list_datasets}}, \code{\link{initiate_sword_dataset}}, \code{\link{delete_sword_dataset}}, \code{\link{publish_sword_dataset}}, \code{\link{add_file}}, \code{\link{delete_file}}
\item Dataverse management \dQuote{native} API: \code{\link{create_dataverse}}, \code{\link{publish_dataverse}}, \code{\link{delete_dataverse}}
\item Dataset management \dQuote{native} API: \code{\link{create_dataset}}, \code{\link{update_dataset}}, \code{\link{publish_dataset}}, \code{\link{delete_dataset}}, \code{\link{dataset_files}}, \code{\link{dataset_versions}}
}
}
\references{
\href{https://iqss.github.io/dataverse-client-r/}{Documentation for this R Package}

\href{https://github.com/iqss/dataverse-client-r/}{Code Repository for the R Package}

\href{https://guides.dataverse.org/en/latest/api/index.html}{Dataverse API Documentation}

\href{https://dataverse.org/}{Dataverse Homepage}

\href{https://dataverse.harvard.edu/}{Harvard IQSS Dataverse}
}
\seealso{
Useful links:
\itemize{
  \item \url{https://iqss.github.io/dataverse-client-r/}
  \item \url{https://dataverse.org/}
  \item \url{https://github.com/iqss/dataverse-client-r}
  \item Report bugs at \url{https://github.com/iqss/dataverse-client-r/issues}
}

}
\author{
\strong{Maintainer}: Shiro Kuriwaki \email{shirokuriwaki@gmail.com} (\href{https://orcid.org/0000-0002-5687-2647}{ORCID})

Authors:
\itemize{
  \item Will Beasley \email{wibeasley@hotmail.com} (\href{https://orcid.org/0000-0002-5613-5006}{ORCID})
  \item Thomas J. Leeper \email{thosjleeper@gmail.com} (\href{https://orcid.org/0000-0003-4097-6326}{ORCID})
  \item Philip Durbin \email{philipdurbin@gmail.com} (\href{https://orcid.org/0000-0002-9528-9470}{ORCID})
  \item Sebastian Karcher \email{karcher@u.northwestern.edu} (\href{https://orcid.org/0000-0001-8249-7388}{ORCID})
}

Other contributors:
\itemize{
  \item Jan Kanis [contributor]
  \item Edward Jee [contributor]
  \item Johannes Gruber \email{JohannesB.Gruber@gmail.com} (\href{https://orcid.org/0000-0001-9177-1772}{ORCID}) [contributor]
  \item Martin Morgan \email{mtmorgan.xyz@gmail.com} (\href{https://orcid.org/0000-0002-5874-8148}{ORCID}) [contributor]
}

}
