% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aboutApp.R
\name{aboutApp}
\alias{aboutApp}
\alias{aboutServer}
\alias{aboutOutput}
\title{About App}
\usage{
aboutApp(id)

aboutServer(id, helppath = NULL, entry = shiny::reactive(TRUE))

aboutOutput(id)
}
\arguments{
\item{id}{identifier for shiny reactive}

\item{helppath}{path to help markdown}

\item{entry}{entry logical flag}
}
\value{
reactive server
}
\description{
About App
}
