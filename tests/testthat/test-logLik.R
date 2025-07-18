test_that("logLik function works correctly", {
  library(survival)
  withr::local_seed(1234)
  temp <- generate_cure_data(n = 100, j = 10, n_true = 10, a = 1.8)
  training <- temp$training
  fit <- curegmifs(Surv(Time, Censor) ~ .,
                   data = training, x_latency = training,
                   model = "weibull", thresh = 1e-4, maxit = 2000,
                   epsilon = 0.01, verbose = FALSE
  )
  expect(round(logLik(fit), 5), -9.22893)
  expect(length(logLik(fit)), 1)
  expect_type(logLik(fit), "double")
})
