context("Find the restriction site")
library(rsrm)

test_that("find the distribution of RS", {
  seq1 <- 'GGCAGATTCCCCCTAACGTCGGACCCGCCCGCACCATGGTCAGGCATGCCCCTCCTCATCGCTGGGCACAGCCCAGAGGGT
  ATAAACAGTGCTGGAGGCTGGCGGGGCAGGCCAGCTGAGTCCTGAGCAGCAGCCCAGCGCAGCCACCGAGACACC
  ATGAGAGCCCTCACACTCCTCGCCCTATTGGCCCTGGCCGCACTTTGCATCGCTGGCCAGGCAGGTGAGTGCCCC'
  name1 <- 'Example gene for test findre (EGFTF)'
  seq2 <- 'ACGTCG'
  name2 <- 'Target'
  result <- findre(name1, seq1, name2, seq2)

  expect_is(result, "ggplot")
})
