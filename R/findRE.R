#' Find the Restriction enzymes which can produce the target sequence
#'
#' A function that find a combination of the restriction enzymes
#' which can produce a fragment contains target sequnce by digest reaction
#'
#' @param dna The FASTA file of the sequence
#' @param targetT he FASTA file of the target sequence you want to produce
#'
#' @return a list of Restriction enzymes combination
#'
#' @import seqRFLP
#'
#'
findre <- function(dna, target, enz = data(enzdata)){
  # read FASTA files
  dna.name <- read.fasta(dna)[1]
  dna.seq <- read.fasta(dna)[2]
  target.name<- read.fasta(target)[1]
  target.seq <- read.fasta(target)[2]

  print(enz[1][1])

  return(TRUE)
}


#' Build FASTA file
#'
#' A function helps users to build their own FASTA file
#'
#' @param name The name of the sequence
#' @param sequences The string of sequences
#' @param file_name The name of FASTA file
#'
#' @return a FASTA file
#'
#'
#'
buildfas <- function(name, sequences, file_name){
  seqinr::write.fasta(sequences, name, file_name, as.string = TRUE)
  return(file_name)
}
