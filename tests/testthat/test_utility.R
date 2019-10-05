context("Utility")
library("rsrm")

test_that("convert ACGT to regex", {
  site <- "TA_CTGA'T"
  regex <- "TACTGAT"
  site_regex <- rs2regex(site)

  expect_equal(site_regex, regex)
})


test_that("convert degenerate base to regex", {
  site <- "nrwby"
  regex <- "[ATCG][AG][AT][GTC][CT]"
  site_regex <- rs2regex(site)

  expect_equal(site_regex, regex)
})


test_that("correctness of cutpos()", {
  dnaseq <- "ATCGGTTATAAGCAT"
  enz <- "AanI"
  dataset <- redata
  cut_pos <- cutpos(dnaseq = dnaseq, enz = enz, dataset = redata)

  expect_equal(cut_pos$start[1], 6)
  expect_equal(cut_pos$end[1], 11)
})
