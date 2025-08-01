#' @srrstats {G5.2b} *Explicit tests should demonstrate conditions which trigger every one of those messages, and should compare the result with expected values.*
#' @srrstats {G5.5} *Correctness tests should be run with a fixed random seed*
#' @srrstats {G5.6} **Parameter recovery tests** *to test that the implementation produce expected results given data with known properties. For instance, a linear regression algorithm should return expected coefficient values for a simulated data set generated from a linear model.*
#' @srrstats {G5.6a} *Parameter recovery tests should generally be expected to succeed within a defined tolerance rather than recovering exact values.*
#' @srrstats {G5.9} **Noise susceptibility tests** *Packages should test for expected stochastic behaviour, such as through the following conditions:*
#' @srrstats {G5.9a} *Adding trivial noise (for example, at the scale of `.Machine$double.eps`) to data does not meaningfully change results*

test_that("cureem works correctly", {
# validate function output
  library(survival)
  withr::local_seed(1234)
  temp <- generate_cure_data(n = 80, j = 100, n_true = 10, a = 1.8)
  training <- temp$training
  fit <- cureem(Surv(Time, Censor) ~ .,
                data = training, x_latency = training,
                model = "cox", penalty = "lasso", lambda_inc = 0.1,
                lambda_lat = 0.1, gamma_inc = 6, gamma_lat = 10
  )
  expect_equal(names(fit), c("b_path", "beta_path", "b0_path", "logLik",
                             "x_incidence", "x_latency", "y",
                             "model", "scale", "method", "call", "cv" ))
  expect_true(class(fit) == "mixturecure")
  expect_true(class(fit$b_path)[1] == "matrix")
  expect_true(class(fit$beta_path)[1] == "matrix")
  expect_true(class(fit$b0_path) == "numeric")
  expect_true(class(fit$logLik) == "numeric")
  expect_equal(round(fit$b0_path[1], 7), 0.5035067)

  fit <- cureem(Surv(Time, Censor) ~ .,
                data = training, x_latency = training,
                model = "cox", penalty = "MCP", lambda_inc = 0.1,
                lambda_lat = 0.1, gamma_inc = 6, gamma_lat = 10
  )
  expect_equal(names(fit), c("b_path", "beta_path", "b0_path", "logLik",
                             "x_incidence", "x_latency", "y",
                             "model", "scale", "method", "call", "cv" ))
  expect_true(class(fit) == "mixturecure")
  expect_true(class(fit$b_path)[1] == "matrix")
  expect_true(class(fit$beta_path)[1] == "matrix")
  expect_true(class(fit$b0_path) == "numeric")
  expect_true(class(fit$logLik) == "numeric")

  fit <- cureem(Surv(Time, Censor) ~ .,
                data = training, x_latency = training,
                model = "cox", penalty = "SCAD", lambda_inc = 0.1,
                lambda_lat = 0.1, gamma_inc = 6, gamma_lat = 10
  )
  expect_equal(names(fit), c("b_path", "beta_path", "b0_path", "logLik",
                             "x_incidence", "x_latency", "y",
                             "model", "scale", "method", "call", "cv" ))
  expect_true(class(fit) == "mixturecure")
  expect_true(class(fit$b_path)[1] == "matrix")
  expect_true(class(fit$beta_path)[1] == "matrix")
  expect_true(class(fit$b0_path) == "numeric")
  expect_true(class(fit$logLik) == "numeric")


  fit <- cureem(Surv(Time, Censor) ~ .,
                data = training, x_latency = training,
                model = "weibull", penalty = "lasso", lambda_inc = 0.1,
                lambda_lat = 0.1, gamma_inc = 6, gamma_lat = 10
  )
  expect_equal(names(fit), c("b_path", "beta_path", "b0_path", "logLik",
                             "x_incidence", "x_latency", "y",
                             "model", "scale", "method", "call", "rate_path",
                             "alpha_path", "cv" ))
  expect_true(class(fit) == "mixturecure")
  expect_true(class(fit$b_path)[1] == "matrix")
  expect_true(class(fit$beta_path)[1] == "matrix")
  expect_true(class(fit$b0_path) == "numeric")
  expect_true(class(fit$logLik) == "numeric")
  expect_equal(round(fit$b0_path[1], 7), 0.2008767)

  fit <- cureem(Surv(Time, Censor) ~ .,
                data = training, x_latency = training,
                model = "exponential", penalty = "lasso", lambda_inc = 0.1,
                lambda_lat = 0.1, gamma_inc = 6, gamma_lat = 10
  )
  expect_equal(names(fit), c("b_path", "beta_path", "b0_path", "logLik",
                             "x_incidence", "x_latency", "y",
                             "model", "scale", "method", "call", "rate_path",
                              "cv" ))
  expect_true(class(fit) == "mixturecure")
  expect_true(class(fit$b_path)[1] == "matrix")
  expect_true(class(fit$beta_path)[1] == "matrix")
  expect_true(class(fit$b0_path) == "numeric")
  expect_true(class(fit$logLik) == "numeric")

  expect_error(cureem(training$Time))
  training$group <- gl(2, 30)
  training$penalty <- rnorm(dim(training)[1])
  expect_error(cureem(Surv(Time, Censor) ~ .,
                      data = training, x_latency = training,
                      subset = group))
  expect_error(cureem(Surv(Time, Censor) ~ .,
                      data = training, x_latency = testing))
  expect_error(cureem(Surv(Time, Censor) ~ .,
                      data = training, x_latency = training,
                      subset = group))
  expect_error(cureem(Surv(Time, Censor) ~ .,
                      data = training, x_latency = training,
                      penalty_factor_inc = penalty))
  expect_error(cureem(Surv(Time, Censor) ~ .,
                      data = training, x_latency = training, lambda_inc = -1))
  expect_error(cureem(Surv(Time, Censor) ~ .,
                      data = training, x_latency = training, lambda_lat = -1))
  expect_error(cureem(Surv(Time, Censor) ~ ., penalty = "MCP",
                      data = training, x_latency = training, gamma_inc = -1))
  expect_error(cureem(Surv(Time, Censor) ~ ., penalty = "MCP",
                      data = training, x_latency = training, gamma_lat = -1))
})
