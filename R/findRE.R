#' Find the Restriction enzymes which can produce the target sequence
#'
#' A function that find a combination of the restriction enzymes
#' which can produce a fragment contains target sequnce by digest reaction
#'
#' @param dna The FASTA file of the sequence
#' @param target The FASTA file of the target sequence you want to produce
#' @param  dataset The dataset stores the information of enzymes
#'
#' @return a list of Restriction enzymes combination
#'
#' @import seqinr
#' @import stringr
#'
#'
findre <- function(dna, target, dataset = redata){


  # read FASTA files
  fas_dna <- seqinr::read.fasta(dna, as.string = TRUE)
  fas_target <- seqinr::read.fasta(target, as.string = TRUE)

  dna.name <- attr(fas_dna, 'name')
  dna.seq <- stringr::str_to_upper(toString(fas_dna))

  target.name<- attr(fas_target, 'name')
  target.seq <- stringr::str_to_upper(toString(fas_target))


  # locate the target sequence
  pos <- stringr::str_locate(dna.seq, target.seq)
  cat(toString(nrow(pos)), 'hits found\n' )
  print(pos)
  target.start <- pos[1, 1]
  target.end <- pos[1, 2]
  cat("start at index", target.start, "end at index", target.end, '\n')
  cat("start at", seqinr::s2c(dna.seq)[pos[1]], 'end at', seqinr::s2c(dna.seq)[pos[2]], '\n')

  cut_pos <- matrix(ncol = 3)

  #get the cut postion of all enzymes
  for (i in 1:nrow(dataset)) {
    enzname <- toString(dataset[i,][['name']])
    pos <- cutpos(dna.seq, enzname, dataset)

    #if found
    if (!any(is.na(pos))) {
      #add to cut_pos
      cut_pos <- rbind(cut_pos, pos)
    }
  }
  print(head(cut_pos))

  cat( "nrow", nrow(cut_pos))


  #subsetting
  #feasible <- subset(cut_pos, )


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
