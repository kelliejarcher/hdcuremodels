% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cure_estimate.R
\name{cure_estimate}
\alias{cure_estimate}
\title{Estimate cured fraction}
\usage{
cure_estimate(object)
}
\arguments{
\item{object}{a \code{survfit} object.}
}
\value{
estimated proportion of cured observations
}
\description{
Estimates the cured fraction using a Kaplan-Meier fitted object.
}
\examples{
library(survival)
withr::local_seed(1234)
temp <- generate_cure_data(n = 100, j = 10, n_true = 10, a = 1.8)
training <- temp$training
km_fit <- survfit(Surv(Time, Censor) ~ 1, data = training)
cure_estimate(km_fit)
}
\seealso{
\code{\link[survival]{survfit}}, \code{\link{sufficient_fu_test}},
\code{\link{nonzerocure_test}}
}
\keyword{univar}
