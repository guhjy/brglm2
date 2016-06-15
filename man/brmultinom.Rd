% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/brmultinom.R
\name{brmultinom}
\alias{brmultinom}
\title{Bias reduction for multinomial response models using the
"Poisson trick". See Kosmidis & Firth (2011) for details}
\usage{
brmultinom(formula, data, weights, subset, na.action, contrasts = NULL,
  control = list(...), ...)
}
\description{
Bias reduction for multinomial response models using the
"Poisson trick". See Kosmidis & Firth (2011) for details
}
\details{
This function is a wrapper for brglmFit.R that can be used to get
bias reduced estimates for the parameters of multinomial regression
models. The implementation is based on constructing an appropriate
model matrix by taking a Kronecker product
(\url{https://en.wikipedia.org/wiki/Kronecker_product}) of the
model matrix X implied by the formula and augmenting it with
\code{nrow(X)} dummy variables, to indi

uses the \pkg{Matrix} package to
}
