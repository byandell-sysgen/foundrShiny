% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/panelApp.R
\name{panelApp}
\alias{panelApp}
\alias{panelServer}
\alias{panelInput}
\alias{panelOutput}
\title{panel App for foundr package}
\usage{
panelApp()

panelServer(
  id,
  traitData = NULL,
  traitSignal = NULL,
  traitStats = NULL,
  customSettings = NULL,
  traitModule = NULL
)

panelInput(id)

panelOutput(id)
}
\arguments{
\item{id}{identifier for shiny reactive}

\item{traitData, traitSignal, traitStats, traitModule}{static objects}

\item{customSettings}{list of custom settings}
}
\value{
reactive server
}
\description{
panel App for foundr package
}
