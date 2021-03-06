% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/brglmControl.R
\name{brglmControl}
\alias{brglmControl}
\alias{brglm_control}
\title{Auxiliary function for \code{\link{glm}} fitting using the
\code{\link{brglmFit}} method.}
\usage{
brglmControl(epsilon = 1e-08, maxit = 100, trace = FALSE,
  type = c("AS_mean", "AS_median", "AS_mixed", "correction", "ML"),
  transformation = "identity", slowit = 1, max_step_factor = 12)
}
\arguments{
\item{epsilon}{positive convergence tolerance epsilon}

\item{maxit}{integer giving the maximal number of iterations
allowed}

\item{trace}{logical indicating if output should be produced for
each iteration}

\item{type}{the type of fitting methodo to be used. The options are
\code{AS_mean} (mean-bias reducing adjusted scores; default),
\code{AS_median} (median-bias reducting adjusted scores),
\code{AS_median} (bias reduction using mixed score adjustents),
\code{correction} (asymptotic bias correction) and \code{ML}
(maximum likelihood).}

\item{transformation}{the transformation of the dispersion to be
estimated. Default is \code{identity}. See Details.}

\item{slowit}{a positive real used as a multiplier for the
stepsize. The smaller it is the smaller the steps are}

\item{max_step_factor}{the maximum number of step halving steps to
consider}
}
\value{
a list with components named as the arguments, including
    symbolic expressions for the dispersion transformation
    (\code{Trans}) and its inverse (\code{inverseTrans})
}
\description{
Typically only used internally by \code{\link{brglmFit}}, but may
be used to construct a \code{control} argument.
}
\details{
\code{\link{brglmControl}} provides default values and
    sanity checking for the various constants that control the
    iteration and generally the behaviour of
    \code{\link{brglmFit}}.

     When \code{trace} is true, calls to \code{cat} produce the
     output for each iteration.  Hence, \code{options(digits = *)}
     can be used to increase the precision.

     \code{transformation} sets the transformation of the
     dispersion parameter for which the bias reduced estimates are
     computed. Can be one of "identity", "sqrt", "inverse", "log"
     and "inverseSqrt". Custom transformations are accommodated by
     supplying a list of two expressions (transformation and
     inverse transformation). See the examples for more details.

\code{brglm_control} is an alias to \code{brglmControl}.
}
\examples{

data("coalition", package = "brglm2")
## The maximum likelihood fit with log link
coalitionML <- glm(duration ~ fract + numst2, family = Gamma, data = coalition)

## Bias reduced estimation of the dispersion parameter
coalitionBRi <- glm(duration ~ fract + numst2, family = Gamma, data = coalition,
                    method = "brglmFit")
coef(coalitionBRi, model = "dispersion")

## Bias reduced estimation of log(dispersion)
coalitionBRl <- glm(duration ~ fract + numst2, family = Gamma, data = coalition,
                    method = "brglmFit", transformation = "log")
coef(coalitionBRl, model = "dispersion")

## Just for illustration: Bias reduced estimation of dispersion^0.25
my_transformation <- list(expression(dispersion^0.25), expression(transformed_dispersion^4))
coalitionBRc <- update(coalitionBRi, transformation = my_transformation)
coef(coalitionBRc, model = "dispersion")

}
\seealso{
\code{\link{brglmFit}} and \code{\link{glm.fit}}
}
\author{
Ioannis Kosmidis \email{ioannis.kosmidis@warwick.ac.uk}
}
