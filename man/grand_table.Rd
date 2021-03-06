% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bayesian.R
\name{grand_table}
\alias{grand_table}
\title{Organize a list of ScenarioInfo objects into a grand table of parameters}
\usage{
grand_table(aScenarioList)
}
\arguments{
\item{aScenarioList}{List of ScenarioInfo structures}
}
\value{
Data frame containing model parameters and log-posterior
probabilities.
}
\description{
The table produced includes the model parameters and log-posterior
probability for all of the models in the input list.
}
\details{
Before this function can run, the scenario list must have been run through
\code{\link{run_bayes}} to compute the posterior probability densities.

Note that the table produced here has \emph{nearly} everything needed to do
inference with the models, but some statistics, such as the WAIC, still
require the pointwise data stored in the ScenarioInfo structures.
}
