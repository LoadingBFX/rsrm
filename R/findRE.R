#' Find the Restriction Sites on given DNA sequence
#'
#' A function that find Restriction Sites on given DNA sequence by given restriction enzyme dataset.
#'
#' @param dna The FASTA file of the sequence, If you don't have FASTA file of sequence,
#'   you can use \code{\link{buildfas}} to build your FASTA file.
#' @param target The FASTA file of the target sequence you want to produce.
#'   same with \code{dna}, you can use \code{\link{buildfas}} to build your FASTA file.
#' @param  dataset The dataset stores the information of enzymes with two column, name and site.
#'
#' @return a list of data frames, first is the location of target,
#'   second is the position of each enzyme cut at,
#'   third is the position of each enzyme cut at the left side of target,
#'   fourth is the position of each enzyme cut at the right side of taget.
#' @examples
#' seq1 <- 'GGCAGATTCCCCCTAACGTCGGACCCGCCCGCACCATGGTCAGGCATGCCCCTCCTCATCGCTGGGCACAGCCCAGAGGGT
#' ATAAACAGTGCTGGAGGCTGGCGGGGCAGGCCAGCTGAGTCCTGAGCAGCAGCCCAGCGCAGCCACCGAGACACC
#' ATGAGAGCCCTCACACTCCTCGCCCTATTGGCCCTGGCCGCACTTTGCATCGCTGGCCAGGCAGGTGAGTGCCCC'
#' name1 <- 'Example gene for test findre (EGFTF)'
#' seq2 <- 'ACGTCG'
#' name2 <- 'Target'
#' file1 <- buildfas(name1, seq1, 'tempfasta1.fas')
#' file2 <- buildfas(name2, seq2, 'tempfasta2.fas')
#' result <- findre(file1, file2)
#' unlink('tempfasta1.fas')
#' unlink('tempfasta2.fas')
#' @export
#'
#' @import seqinr
#' @import stringr
#'
#'
findre <- function(dna, target, dataset = redata) {
    # read FASTA files
    fas_dna <- seqinr::read.fasta(dna, as.string = TRUE)
    fas_target <- seqinr::read.fasta(target, as.string = TRUE)

    dna.name <- attr(fas_dna, "name")
    dna.seq <- stringr::str_to_upper(toString(fas_dna))

    target.name <- attr(fas_target, "name")
    target.seq <- stringr::str_to_upper(toString(fas_target))


    # locate the target sequence
    pos <- stringr::str_locate(dna.seq, target.seq)

    if (any(is.na(pos))) stop("target sequence not found")

    print(pos)
    target.start <- pos[1, 1]
    target.end <- pos[1, 2]
    cat("start at index", target.start, "end at index", target.end, "\n")

    pos.data <- data.frame(name = target.name,
                           start = target.start,
                           end = target.end,
                           seq = target.seq,
                           row.names = "Target")

    # get the cut postion of all enzymes
    for (i in 1:nrow(dataset)) {
        enzname <- toString(dataset[i, ][["name"]])
        pos <- cutpos(dna.seq, enzname, dataset)

        # if found
        if (!any(is.na(pos))) {
            pos.data <- rbind(pos.data, pos)
        }
    }

    target_pos <- pos.data[1, ]
    enz_pos <- pos.data[2:nrow(pos.data), ]
    left <- pos.data[which(pos.data$end < target.start), ]
    right <- pos.data[which(pos.data$start > target.end), ]

    cat(nrow(pos.data), "Restriction Site found on", dna.name, "\n")
    print(head(enz_pos))

    return(list(target_pos, enz_pos, left, right))
}


#' Build FASTA file
#'
#' A function helps users to build their own FASTA file
#'
#' @param name String, the name of the sequence
#' @param sequences String, the sequences
#' @param file_name String, The name of FASTA file
#'
#' @return Create a FASTA file and return the it's name
#' @examples
#' seq <- 'ACGTCG'
#' name <- 'Target'
#' file <- buildfas(name, seq, 'tempfasta.fas')
#' fas_seq <- seqinr::read.fasta(file, as.string = TRUE)
#' attr(fas_seq, 'name')
#' toString(fas_seq)
#'
#' @export
#' @import seqinr
#'
buildfas <- function(name, sequences, file_name) {
    seqinr::write.fasta(sequences, name, file_name, as.string = TRUE)
    return(file_name)
}
