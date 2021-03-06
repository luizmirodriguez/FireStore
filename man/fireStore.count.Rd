% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FireStore.R
\name{fireStore.count}
\alias{fireStore.count}
\title{Count allows us to count records from a Cloud Firestore collection}
\usage{
fireStore.count(project_id, fileName, token)
}
\arguments{
\item{project_id}{This is the unique identifier of your Firebase project {string}}

\item{fileName}{Name of the collection {string}}

\item{token}{token that returns the function FireStore.google_firestore{string}}
}
\value{
returns a number of the number of records
}
\description{
fireStore::fireStore.count returns a number of the number of records
}
\examples{
\dontrun{
fireStore.count("mi-proyecto-6465" , "micoleccion", "KxwWNTVdplXFRZwGMkH")
}
}
\author{
Luis Rodriguez
}
