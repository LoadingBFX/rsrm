#' Visualize the distribution of restriction site arround the target sequence
#'
#' This function will plot the restriction site map by given number of sites
#' you can choose how many sites at left/right of target to display.
#'
#' @param dna The FASTA file of the sequence
#' @param target The FASTA file of the target sequence you want to produce
#' @param dataset The dataset stores the information of enzymes
#' @param num The number of enzyme on the left/right side of target sequence
#'
#' @return the distribution of restriction site arround the target sequence
#'
#' @examples
#' seq1 <- 'GGCAGATTCCCCCTAGACCCGCCCGCACCATGGTCAGGCATGCCCCTCCTCATCGCTGGGCACAGCCCAGAGGGT
#' ATAAACAGTGCTGGAGGCTGGCGGGGCAGGCCAGCTGAGTCCTGAGCAGCAGCCCAGCGCAGCCACCGAGACACC
#' ATGAGAGCCCTCACACTCCTCGCCCTATTGGCCCTGGCCGCACTTTGCATCGCTGGCCAGGCAGGTGAGTGCCCC'
#' name1 <- "Example gene for test findre (EGFTF)"
#' seq2 <- "ACGTCG"
#' name2 <- "Target"
#' file1 <- buildfas(name1, seq1, 'tempfasta1.fas')
#' file2 <- buildfas(name2, seq2, 'tempfasta2.fas')
#' result <- rsplot(file1, file2, dataset = redata)
#' unlink('tempfasta1.fas')
#' unlink('tempfasta2.fas')
#'
#'
#' @export
#' @import ggplot2
#' @import stringr
#'
rsplot <- function(dna, target, dataset = redata, num = 10) {

    temp <- findre(dna, target, dataset)

    # Get DNA name
    fas_dna <- seqinr::read.fasta(dna, as.string = TRUE)
    fas_target <- seqinr::read.fasta(target, as.string = TRUE)

    dna.name <- attr(fas_dna, "name")
    target.name <- attr(fas_target, "name")


    target_pos <- data.frame(temp[1])
    l <- data.frame(temp[3])
    r <- data.frame(temp[4])


    # sort left(descending)/right(ascending)
    left <- l[order(-l$end), ]
    right <- r[order(r$start), ]

    plot_data <- rbind(target_pos, left[1:num, ], right[1:num, ])
    title <- str_c(" Restriction Site Arround ", target.name)

    ggplot(plot_data, aes(x = start, y = name, color = name)) + geom_point(shape = 1, size = 6) + geom_vline(xintercept = target_pos$start[1], color = "#FF3333") + ggtitle(title) + xlab(dna.name) + ylab("Restriction Enzymes")
}
