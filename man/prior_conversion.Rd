% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{prior_conversion}
\alias{prior_conversion}
\title{Construct prior based on d-step prediction SD.}
\usage{
prior_conversion(d, prior, p)
}
\arguments{
\item{d}{A numeric value for the prediction step.}

\item{prior}{A list that contains a and u. This specifies the target prior on the d-step SD \eqn{\sigma(d)}, such that \eqn{P(\sigma(d) > u) = a}.}

\item{p}{An integer for the order of IWP.}
}
\value{
A list that contains a and u. The prior for the smoothness parameter \eqn{\sigma} such that \eqn{P(\sigma > u) = a}, that yields the ideal prior on the d-step SD.
}
\description{
Construct prior based on d-step prediction SD.
}
