% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sampledb.R
\name{create_study}
\alias{create_study}
\title{Create Study}
\usage{
create_study(
  title,
  short_code,
  is_longitudinal,
  lead_person,
  description = NULL
)
}
\arguments{
\item{title}{the title of the study}

\item{short_code}{a short unique string that is used to refer to the study}

\item{is_longitudinal}{logical indicating if the study is a longitudinal
study. Setting this value will result in extra logical checks when adding
samples to ensure they have collection dates associated}

\item{lead_person}{the person responsible for the study samples}

\item{description}{an optional field to give more context to the study}
}
\value{
returns the study object created
}
\description{
Create a new study entry in the database. Throws a ValueError if
the short_code is not unique
}
