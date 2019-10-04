context("Find the restriction site")
library('rsrm')
library('stringr')

test_that("build the fasta file",{
  seq <- "ACGTCG"
  name <- "Target"
  file <- buildfas(name, seq, 'tempfasta.fas')
  fas_seq <- seqinr::read.fasta(file, as.string = TRUE)
  toString(fas_seq)

  expect_equal(attr(fas_seq, "name"), name)
  expect_equal(str_to_upper(toString(fas_seq)), seq)
})

test_that("find the distribution of RS",{
  seq1 <- 'GGCAGATTTATAATCCCCCTAGAACGTCGCCCGCCCGCACCATGGTGACACTGCAGTCCAGGCATGCC'
  name1 <- "Example gene for test findre (EGFTF)"
  seq2 <- "ACGTCG"
  name2 <- "Target"
  dataset <- redata[1:6, ]
  file1 <- buildfas(name1, seq1, 'tempfasta1.fas')
  file2 <- buildfas(name2, seq2, 'tempfasta2.fas')
  result <- findre(file1, file2, dataset)
  unlink('tempfasta1.fas')
  unlink('tempfasta2.fas')

  expect_is(result, "list")
  expect_equal(length(result), 4)
})

