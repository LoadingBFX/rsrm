#' Construct restriction map by given fragments
#'
#' This function will visualize the restriction site map,
#' by given single and double digests reaction result.
#' Assume the input sequence is circular.
#'
#' @param enz1 the name of first enzyme.
#' @param frag1 the int vector of result of
#'   the single digests reaction by enzyme1.
#' @param enz2 the name of second enzyme.
#' @param frag2 the int vector of result of
#'   the single digests reaction by enzyme2.
#' @param dou_dig the int vector of result of the
#'   double digests reaction by enzyme1 and enzyme2.
#' @param name the name of tested sequence
#'
#' @return restriction map
#'
#
#' @examples
#' frag1 <- c(100)
#' frag2 <- c(50, 25, 20, 5)
#' dou_dig <- c(25, 25, 25, 20, 5)
#' enz1 <- 'enz1'
#' enz2 <- 'enz2'
#' rsmap(enz1, frag1, enz2, frag2, dou_dig)
#'
#' @export
#' @import ggplot2
#' @import stringr
#'
rsmap <- function(enz1, frag1, enz2, frag2, dou_dig, name = "Unknow Seq") {

    cat("INPUT QUESTION:",
        "\n------",
        enz1, ":",
        frag1,
        "\n------",
        enz2, ":",
        frag2,
        "\n------",
        enz1, '+', enz2, ":",
        dou_dig, '\n\n')

    frag1 <- sort(frag1)
    frag2 <- sort(frag2)
    dou_dig <- sort(dou_dig)

    len1 <- sum(frag1)
    len2 <- sum(frag2)

    if (len1 != len2) {
      stop("The sum length of frag1 must be same with frag2")
    }

    cat("The length of input sequnence is", len1, "\n\n")

    if (length(frag1) > 1) {
        for (i in 2:length(frag1)) {
            frag1[i] <- frag1[i - 1] + frag1[i]
        }
    }

    if (length(frag2) > 1) {
        for (i in 2:length(frag2)) {
            frag2[i] <- frag2[i - 1] + frag2[i]
        }
    }

    cat("looking for feasible solution-----\n\n")

    found <- check_dou(frag1, frag2, dou_dig)

    limit <- len2
    timer <- 0

    while (found && timer <= limit) {
        for (i in 1:length(frag2)) {
            if (frag2[i] < len2) {
                frag2[i] <- frag2[i] + 1
            } else {
                frag2[i] <- frag2[i] + 1 - len2
            }
        }
        frag2 <- sort(frag2)

        found <- check_dou(frag1, frag2, dou_dig)
        timer <- timer + 1
    }

    d1 <- data.frame(xval = frag1,
                     yval = 5,
                     Restriction_Enzymes = enz1,
                     name = name)

    d2 <- data.frame(xval = frag2,
                     yval = 5,
                     Restriction_Enzymes = enz2,
                     name = name)

    dat <- rbind(d1, d2)

    cat("Solution Found--------------------\n",
        "One of the feasible solution: \n",
        nrow(dat), "Restriction Site(s) on",
        name, ":", "\n  ",
        enz1, "cut at", d1$xval,
        "\n  ", enz2, "cut at", d2$xval, '\n\n')

    cat("Constructing RS Map--------------\n")

    title <- stringr::str_c("Restriction Site Map for ",
                   name, " (length = ", len1, ")")

    ggplot(dat, aes(x = xval, y = yval,
                    color = Restriction_Enzymes,
                    shape = Restriction_Enzymes)) +
      xlim(0, len1) +
      geom_point(size = 3) +
      geom_hline(yintercept = 5) +
      theme_minimal() +
      theme(axis.text = element_blank(), axis.title = element_blank(),
        panel.grid = element_blank(), ) +
      coord_polar(start = 0) +
      labs(title = title)
}


#' Helper function to check if the fragments satisify the double digests reaction
#'
#' The helper function for \code{rsmap} to check
#' if the fragments satisify the double digests reaction
#'
#' @param frag1 the int vector of result of
#'   the single digests reaction by enzyme1.
#' @param frag2 the int vector of result of
#'   the single digests reaction by enzyme2.
#' @param dou_dig the int vector of result of the
#'   double digests reaction by enzyme1 and enzyme2.
#'
#' @return if the fragments cut by enz1 and enz2 is
#'   same with double digests reaction
#'
check_dou <- function(frag1, frag2, dou_dig) {

    fragments <- sort(c(frag1, frag2))
    temp <- fragments[1]

    for (i in 2:length(fragments)) {
        if (fragments[i] - fragments[i - 1] != 0) {
            temp <- c(temp, (fragments[i] - fragments[i - 1]))
        }
    }

    if (length(temp) == length(dou_dig)) {
        same <- sort(temp) == sort(dou_dig)
    } else {
        same <- FALSE
    }
    return(any(!same))
}
