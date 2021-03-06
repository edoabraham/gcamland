% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lagged_expectation.R
\name{LaggedExpectation_calcExpectedPrice}
\alias{LaggedExpectation_calcExpectedPrice}
\title{LaggedExpectation_calcExpectedPrice}
\usage{
LaggedExpectation_calcExpectedPrice(aLandLeaf, aPeriod, aScenarioInfo)
}
\arguments{
\item{aLandLeaf}{LandLeaf to calculate expected price for}

\item{aPeriod}{Current model period}

\item{aScenarioInfo}{Scenario-related information, including names, logits, expectations}
}
\description{
LaggedExpectation_calcExpectedPrice
}
\details{
Calculate the expected price for a LandLeaf using
         a lagged approach -- use linear combination of previous expectation and
         new information.
}
\author{
KVC November 2017
}
