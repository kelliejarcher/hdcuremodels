% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formula.R
\name{formula.mixturecure}
\alias{formula.mixturecure}
\title{Extract model formula for mixturecure object}
\usage{
\method{formula}{mixturecure}(x, ...)
}
\arguments{
\item{x}{an object from class \code{mixturecure}.}

\item{...}{other arguments.}
}
\value{
a formula representing the incidence and variables for the latency
portion of the model
}
\description{
Extract the model formula for \code{mixturecure} object
}
\examples{
library(survival)
withr::local_seed(1234)
temp <- generate_cure_data(n = 100, j = 10, n_true = 10, a = 1.8)
training <- temp$training
fit <- curegmifs(Surv(Time, Censor) ~ .,
  data = training, x_latency = training,
  model = "weibull", thresh = 1e-4, maxit = 2000,
  epsilon = 0.01, verbose = FALSE
)
formula(fit)
}
\keyword{methods}
