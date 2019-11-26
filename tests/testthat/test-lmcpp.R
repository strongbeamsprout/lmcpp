test_that("lmcpp works", {

  expect_equal(lmcpp(mpg ~ cyl + hp, data = mtcars)$coefficients, lm(mpg ~ cyl + hp, data = mtcars)$coefficients)
  expect_equal(lmcpp(mpg ~ cyl + hp, data = mtcars)$df.residual, lm(mpg ~ cyl + hp, data = mtcars)$df.residual)
  expect_equal(lmcpp(dist ~ speed, data = cars)$coefficients, lm(dist ~ speed, data = cars)$coefficients)
  expect_equal(lmcpp(dist ~ speed, data = cars)$df.residual, lm(dist ~ speed, data = cars)$df.residual)
  expect_equal(summary.lmcpp(lmcpp(mpg ~ cyl + hp, data = mtcars), correlation = TRUE, prt = FALSE)$correlation,
               summary(lm(mpg ~ cyl + hp, data = mtcars), correlation = TRUE)$correlation)
  expect_equal(summary.lmcpp(lmcpp(mpg ~ cyl + hp, data = mtcars), correlation = TRUE, prt = FALSE)$coefficients,
               summary(lm(mpg ~ cyl + hp, data = mtcars), correlation = TRUE)$coefficients)
  expect_equal(summary.lmcpp(lmcpp(mpg ~ cyl + hp, data = mtcars), correlation = TRUE, prt = FALSE)$r.squared,
               summary(lm(mpg ~ cyl + hp, data = mtcars), correlation = TRUE)$r.squared)
  expect_equal(summary.lmcpp(lmcpp(dist ~ speed, data = cars), correlation = TRUE, prt = FALSE)$fstatistic,
               summary(lm(dist ~ speed, data = cars), correlation = TRUE)$fstatistic)

})
