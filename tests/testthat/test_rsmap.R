context("Test the return type of rsmap()")
library("rsrm")

test_that("return type", {
  frag1 <- c(100)
  frag2 <- c(50, 25, 20, 5)
  dou_dig <- c(25, 25, 25, 20, 5)
  enz1 <- "enz1"
  enz2 <- "enz2"
  result <- rsmap(enz1, frag1, enz2, frag2, dou_dig)

  expect_is(result, "ggplot")
})
