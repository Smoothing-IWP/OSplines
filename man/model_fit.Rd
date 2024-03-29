% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{model_fit}
\alias{model_fit}
\title{Model fitting with random effects/fixed effects}
\usage{
model_fit(
  formula,
  data,
  method = "aghq",
  family = "Gaussian",
  control.family,
  control.fixed,
  aghq_k = 4
)
}
\arguments{
\item{formula}{A formula that contains one response variable, and covariates with either random or fixed effect.}

\item{data}{A dataframe that contains the response variable and other covariates mentioned in the formula.}

\item{method}{The inference method used in the model. By default, the method is set to be "aghq".}

\item{family}{The family of response used in the model. By default, the family is set to be "Gaussian".}

\item{control.family}{Parameters used to specify the priors for the family parameters, such as the standard deviation parameter of Gaussian family.}

\item{control.fixed}{Parameters used to specify the priors for the fixed effects.}
}
\value{
A list that contains following items: the S4 objects for the random effects (instances), concatenated design matrix for
the fixed effects (design_mat_fixed), fitted aghq (mod) and indexes to partition the posterior samples
(boundary_samp_indexes, random_samp_indexes and fixed_samp_indexes).
}
\description{
Fitting a hierarchical model based on the provided formula, data and parameters such as type of method and family of response.
Returning the S4 objects for the random effects, concatenated design matrix for the intercepts and fixed effects, fitted model,
indexes to partition the posterior samples.
}
\examples{
library(OSplines)
library(tidyverse)

data <- INLA::Munich \%>\% select(rent, floor.size, year, location)
data$score <- rnorm(n = nrow(data))
head(data, n = 5)

### A model with two IWP and two Fixed effects:
## Assume f(floor.size) is second order IWP
## Assume f(year) is third order IWP

fit_result <- model_fit(
  rent ~ location + f(
    smoothing_var = floor.size,
    model = "IWP",
    order = 2
  )
  + score + f(
      smoothing_var = year,
      model = "IWP",
      order = 3, k = 10, # should add a checker for k >= 3
      sd.prior = list(prior = "exp", para = list(u = 1, alpha = 0.5)),
      boundary.prior = list(prec = 0.01)
    ),
  data = data, method = "aghq", family = "Gaussian",
  control.family = list(sd_prior = list(prior = "exp", para = list(u = 1, alpha = 0.5))),
  control.fixed = list(intercept = list(prec = 0.01), location = list(prec = 0.01), score = list(prec = 0.01))
)

# Check the contents of the returned fit result
names(fit_result)
IWP1 <- fit_result$instances[[1]]
IWP2 <- fit_result$instances[[2]]
mod <- fit_result$mod
}
