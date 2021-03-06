# Copyright (C) 2016, 2017 Ioannis Kosmidis

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 or 3 of the License
#  (at your option).
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/


#' Auxiliary function for \code{\link{glm}} fitting using the
#' \code{\link{brglmFit}} method.
#'
#' Typically only used internally by \code{\link{brglmFit}}, but may
#' be used to construct a \code{control} argument.
#'
#' @inheritParams stats::glm.control
#' @aliases brglm_control
#' @param epsilon positive convergence tolerance epsilon
#' @param maxit integer giving the maximal number of iterations
#'     allowed
#' @param trace logical indicating if output should be produced for
#'     each iteration
#' @param type the type of fitting methodo to be used. The options are
#'     \code{AS_mean} (mean-bias reducing adjusted scores; default),
#'     \code{AS_median} (median-bias reducting adjusted scores),
#'     \code{AS_median} (bias reduction using mixed score adjustents),
#'     \code{correction} (asymptotic bias correction) and \code{ML}
#'     (maximum likelihood).
#' @param transformation the transformation of the dispersion to be
#'     estimated. Default is \code{identity}. See Details.
#' @param slowit a positive real used as a multiplier for the
#'     stepsize. The smaller it is the smaller the steps are
#' @param max_step_factor the maximum number of step halving steps to
#'     consider
#'
#' @details \code{\link{brglmControl}} provides default values and
#'     sanity checking for the various constants that control the
#'     iteration and generally the behaviour of
#'     \code{\link{brglmFit}}.
#'
#'      When \code{trace} is true, calls to \code{cat} produce the
#'      output for each iteration.  Hence, \code{options(digits = *)}
#'      can be used to increase the precision.
#'
#'      \code{transformation} sets the transformation of the
#'      dispersion parameter for which the bias reduced estimates are
#'      computed. Can be one of "identity", "sqrt", "inverse", "log"
#'      and "inverseSqrt". Custom transformations are accommodated by
#'      supplying a list of two expressions (transformation and
#'      inverse transformation). See the examples for more details.
#'
#' \code{brglm_control} is an alias to \code{brglmControl}.
#'
#' @return a list with components named as the arguments, including
#'     symbolic expressions for the dispersion transformation
#'     (\code{Trans}) and its inverse (\code{inverseTrans})
#'
#' @author Ioannis Kosmidis \email{ioannis.kosmidis@warwick.ac.uk}
#'
#' @seealso \code{\link{brglmFit}} and \code{\link{glm.fit}}
#'
#' @examples
#'
#' data("coalition", package = "brglm2")
#' ## The maximum likelihood fit with log link
#' coalitionML <- glm(duration ~ fract + numst2, family = Gamma, data = coalition)
#'
#' ## Bias reduced estimation of the dispersion parameter
#' coalitionBRi <- glm(duration ~ fract + numst2, family = Gamma, data = coalition,
#'                     method = "brglmFit")
#' coef(coalitionBRi, model = "dispersion")
#'
#' ## Bias reduced estimation of log(dispersion)
#' coalitionBRl <- glm(duration ~ fract + numst2, family = Gamma, data = coalition,
#'                     method = "brglmFit", transformation = "log")
#' coef(coalitionBRl, model = "dispersion")
#'
#' ## Just for illustration: Bias reduced estimation of dispersion^0.25
#' my_transformation <- list(expression(dispersion^0.25), expression(transformed_dispersion^4))
#' coalitionBRc <- update(coalitionBRi, transformation = my_transformation)
#' coef(coalitionBRc, model = "dispersion")
#'
#' @export
brglmControl <- function(epsilon = 1e-08, maxit = 100,
                         trace = FALSE,
                         type = c("AS_mean", "AS_median", "AS_mixed", "correction", "ML"),
                         transformation = "identity",
                         slowit = 1,
                         max_step_factor = 12) {
    type <- match.arg(type)

    if (is.character(transformation)) {
        Trans <- switch(transformation,
                        identity = expression(dispersion),
                        sqrt = expression(dispersion^0.5),
                        inverse = expression(1/dispersion),
                        log = expression(log(dispersion)),
                        inverseSqrt = expression(1/sqrt(dispersion)),
                        stop(transformation, " is not one of the implemented dispersion transformations"))
        inverseTrans <- switch(transformation,
                               identity = expression(transformed_dispersion),
                               sqrt = expression(transformed_dispersion^2),
                               inverse = expression(1/transformed_dispersion),
                               log = expression(exp(transformed_dispersion)),
                               inverseSqrt = expression(1/transformed_dispersion^2))
    }
    else {
        if (is.list(transformation) && (length(transformation) == 2)) {
            Trans <- transformation[[1]]
            inverseTrans <- transformation[[2]]
            transformation <- "custom_transformation"
        }
        else {
            stop("transformation can be either one of 'identity', 'sqrt', 'inverse', 'log' and 'inverseSqrt', or a list of two expressions")
        }
    }
    if (!is.numeric(epsilon) || epsilon <= 0)
        stop("value of 'epsilon' must be > 0")
    list(epsilon = epsilon, maxit = maxit, trace = trace,
         type = type,
         Trans = Trans,
         inverseTrans = inverseTrans,
         transformation = transformation,
         slowit = slowit,
         max_step_factor = max_step_factor)
}

