% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sampledb.R
\name{delete_study_by_id}
\alias{delete_study_by_id}
\title{Delete study by ID}
\usage{
delete_study_by_id(study_id)
}
\arguments{
\item{study_id}{integer ID of study to delete}
}
\value{
returns TRUE if the study was deleted
}
\description{
Delete study by ID. Deletion will delete all samples and storage
containers associated.
}
