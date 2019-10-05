context("Test the return type of rsplot()")
library("rsrm")

test_that("return type", {
  seq1 <- "GGCAGATTTATAATCCCCCTAGAACGTCGCCCGCCCGCACCATGGTGACACTGCAGTCCAGGCATGCC"
  name1 <- "Example gene for test findre (EGFTF)"
  seq2 <- "ACGTCG"
  name2 <- "Target"
  dataset <- redata[1:6, ]
  file1 <- buildfas(name1, seq1, "tempfasta1.fas")
  file2 <- buildfas(name2, seq2, "tempfasta2.fas")
  plot <- rsplot(file1, file2, dataset)
  unlink("tempfasta1.fas")
  unlink("tempfasta2.fas")

  expect_is(plot, "ggplot")
})
