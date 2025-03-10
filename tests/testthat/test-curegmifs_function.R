test_that("curegmifs works correctly", {
    # validate function output
    library(survival)
    set.seed(1234)
    temp <- generate_cure_data(n = 100, j = 10, n_true = 10, a = 1.8)
    training <- temp$training
    fit <- curegmifs(Surv(Time, Censor) ~ .,
                   data = training, x_latency = training, scale = TRUE,
                   model = "weibull", thresh = 1e-4, maxit = 2000, epsilon = 0.01,
                   verbose = FALSE
    )
    expect_setequal(names(fit), c("b_path", "beta_path", "b0_path", "rate_path",
                               "logLik", "x_incidence", "x_latency", "y",
                               "model", "scale", "method", "call", "alpha_path",
                               "cv" ))
    fit %>% expect_s3_class("mixturecure")
    fit$b0_path %>% expect_type("double")
    fit$b_path %>% expect_type("double")
    fit$beta_path %>% expect_type("double")
    fit$rate_path %>% expect_type("double")
    fit$logLik %>% expect_type("double")
    fit$x_incidence %>% expect_type("double")
    fit$x_latency %>% expect_type("double")
    fit$y %>% expect_type("double")
    fit$model %>% expect_type("character")
    fit$scale %>% expect_type("logical")
    fit$method %>% expect_type("character")
    fit$alpha_path %>% expect_type("double")
    fit$cv %>% expect_type("logical")
    expect_equal(round(fit$x_incidence[1, 1], 7), 0.1557627)
    expect_equal(round(fit$x_latency[1, 1], 7), 0.1557627)
    expect_equal(fit$model, "weibull")
    expect_equal(round(fit$alpha_path[1], 4), 0.5593)
    expect_equal(round(fit$b0_path[1], 4), 0.1413)
    expect_equal(fit$cv, FALSE)
    expect_equal(fit$method, "GMIFS")
    expect_equal(fit$scale, TRUE)
    expect_error(curegmifs(Time ~ ., data = training, x_latency = training))
    expect_error(curegmifs(Censor ~ ., data = training, x_latency = training))
    expect_equal(dim(fit$b_path)[2], dim(fit$x_incidence)[2])
    expect_equal(dim(fit$beta_path)[2], dim(fit$x_latency)[2])
    fit$b0_path %>% expect_length(dim(fit$beta_path)[1])
    fit$alpha_path %>% expect_length(length(fit$b0_path))
    fit$rate_path %>% expect_length(length(fit$b0_path))
    fit$logLik %>% expect_length(length(fit$b0_path))
    set.seed(1234)
    temp <- generate_cure_data(n = 400, j = 10, n_true = 10, a = 1.8)
    training <- temp$training

    fit <- curegmifs(Surv(Time, Censor) ~ .,
                     data = training, x_latency = training, scale = TRUE,
                     model = "exponential", thresh = 1e-4, maxit = 2000, epsilon = 0.01,
                     verbose = FALSE
    )
    expect_setequal(names(fit), c("b_path", "beta_path", "b0_path", "rate_path",
                                  "logLik", "x_incidence", "x_latency", "y",
                                  "model", "scale", "method", "call", "cv" ))
    fit %>% expect_s3_class("mixturecure")
    fit$b0_path %>% expect_type("double")
    fit$b_path %>% expect_type("double")
    fit$beta_path %>% expect_type("double")
    fit$rate_path %>% expect_type("double")
    fit$logLik %>% expect_type("double")
    fit$x_incidence %>% expect_type("double")
    fit$x_latency %>% expect_type("double")
    fit$y %>% expect_type("double")
    fit$model %>% expect_type("character")
    fit$scale %>% expect_type("logical")
    fit$method %>% expect_type("character")
    fit$cv %>% expect_type("logical")
    expect_equal(round(fit$x_incidence[1, 1], 7), 0.1557627)
    expect_equal(round(fit$x_latency[1, 1], 7), 0.1557627)
    expect_equal(fit$model, "exponential")
    expect_equal(round(fit$b0_path[1], 4), 0.3305)
    expect_equal(fit$cv, FALSE)
    expect_equal(fit$method, "GMIFS")
    expect_equal(fit$scale, TRUE)
    expect_error(curegmifs(Time ~ ., data = training, x_latency = training))
    expect_error(curegmifs(Censor ~ ., data = training, x_latency = training))
    expect_equal(dim(fit$b_path)[2], dim(fit$x_incidence)[2])
    expect_equal(dim(fit$beta_path)[2], dim(fit$x_latency)[2])
    fit$b0_path %>% expect_length(dim(fit$beta_path)[1])
    fit$rate_path %>% expect_length(length(fit$b0_path))
    fit$logLik %>% expect_length(length(fit$b0_path))

    expect_error(curegmifs(Surv(Time, Censor) ~ .,
                     data = training, x_latency = training, scale = TRUE,
                     model = "exponential", thresh = -10, maxit = 2000, epsilon = 0.01,
                     verbose = FALSE))

})

