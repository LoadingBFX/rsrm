#' Find the Restriction Sites on given DNA sequence
#'
#' A function that find Restriction Sites on given DNA sequence by given restriction enzyme dataset.
#' and plot the restriction site map by given number of sites you can choose how many sites at left/right of target to display.
#'
#' @param dnaName String, The name of the DNA sequence,
#' @param dnaSeq String, The sequence of the DNA
#' @param targetName String, The name of the target you want to produce, defualt is just "Target".
#' @param targetSeq String, The sequence of the target you want to produce.
#' @param dataset The dataset stores the information of enzymes with two column, name and site.
#' @param num The number of enzyme on the left/right side of target sequence, defualt is 6
#' @param title The title of the plot.defualt is "Restriction map around the target sequence"
#'
#'
#' @return the distribution of restriction site arround the target sequence
#' @examples
#' seq1 <- 'GGCAGATTCCCCCTAACGTCGGACCCGCCCGCACCATGGTCAGGCATGCCCCTCCTCATCGCTGGGCACAGCCCAGAGGGT
#' ATAAACAGTGCTGGAGGCTGGCGGGGCAGGCCAGCTGAGTCCTGAGCAGCAGCCCAGCGCAGCCACCGAGACACC
#' ATGAGAGCCCTCACACTCCTCGCCCTATTGGCCCTGGCCGCACTTTGCATCGCTGGCCAGGCAGGTGAGTGCCCC'
#' name1 <- 'example DNA Sequence'
#' seq2 <- 'ACGTCG'
#' name2 <- 'Target'
#' result <- findre(name1, seq1, name2, seq2)
#' result
#'
#' @export
#'
#' @import seqinr
#' @import stringr
#' @import ggplot2
#' @import gggenes
#'
findre <- function(dnaName = 'example DNA Sequence', dnaSeq,
                   targetName = "Target", targetSeq, dataset = redata,
                   num = 6, title = "Restriction map around the target sequence") {
    # clean the sequence to make sure the sequence is a vaild DNA sequence.
    dnaSeq <- sanitizeSeq(dnaSeq)
    targetSeq <- sanitizeSeq(targetSeq)

    # locate the target sequence
    pos <- stringr::str_locate(dnaSeq, targetSeq)

    if (any(is.na(pos))) {
        message("target sequence not found")
        return(0)
        }

    # Currently only use the first hit of target
    target.start <- pos[1, 1]
    target.end <- pos[1, 2]
    cat("# Target starts at index", target.start, "ends at index", target.end, "\n\n")

    pos.data <- data.frame(name = targetName,
                           seq = targetSeq,
                           start = target.start,
                           end = target.end,
                           row.names = "0")

    # get the cut postion of all enzymes
    for (i in 1:nrow(dataset)) {
        enzname <- toString(dataset[i, ][["name"]])
        pos <- cutpos(dnaSeq, enzname, dataset)

        # if found
        if (!any(is.na(pos))) {
            pos.data <- rbind(pos.data, pos)
        }
    }


    # data frame of target position
    target_pos <- pos.data[1, ]

    # data frame of all enzymes which has RS on DNA.
    enz_pos <- pos.data[2:nrow(pos.data), ]

    # data frame of enzymes which has RS on the left side of target
    left <- pos.data[which(pos.data$end < target.start), ]

    # data frame of enzymes which has RS on the right side of target
    right <- pos.data[which(pos.data$start > target.end), ]

    cat(nrow(enz_pos), "Restriction Site found on", dnaName, "head of enzymes showed below\n")
    print(head(enz_pos))


    #################### Visualization ############################
    cat("\ngenerating the restriction map...\n")

    # sort left(descending)/right(ascending)
    left <- left[order(-left$end), ]
    right <- right[order(right$start), ]

    numLeft <- num
    numRight <- num

    if ( num > nrow(left)) {
        numLeft <- nrow(left)
        cat("Only", numLeft, "RS can be found at the left side of target\n")
    }

    if ( num > nrow(right)) {
        numRight <- nrow(right)
        cat("Only", numRight, "RS can be found at the right side of target")
    }

    cat("Totally", numLeft + numRight, "restriction sites displayed\n", numLeft, "on the left,", numRight, "on the right\n")
    x <- paste("Index of", dnaName)

    data <- target_pos
    if (!any(is.na(left[1:numLeft, ]))) {
        data <- rbind(data, left[1:numLeft, ])
    }

    if (!any(is.na(right[1:numRight, ]))) {
        data <- rbind(data, right[1:numRight, ])
    }

    p <- ggplot2::ggplot(data, aes(xmin = start, xmax = end, y = name, fill = seq)) +
        gggenes::geom_gene_arrow() +
        xlab(x) +
        ylab("Restriction Enzymes") +
        ggtitle(title) +
        gggenes::theme_genes()

    return(p)
}

#[END]
