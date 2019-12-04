# to avoid "no visible binding for global variable" note
utils::globalVariables(c("Restriction_Enzymes","name",
                         "redata", "site","head",
                         "start", "xval", "yval", "end"))


#' Find the position cut by given enzyme
#'
#' A function to locate the cut site of given enzyme and enzyme dataset.
#'
#' @param dnaseq a string of DNA sequence
#' @param enz the name of enzyme
#' @param dataset the data used to store enzyme info (name and site)
#'
#' @return a data frame of cut position (name, seq, start and end), if not found, return NA.
#' @examples
#' dnaSeq <- 'ATCGGTTATAAGCAT'
#' enz <- 'AanI'
#' cutpos(dnaSeq, enz, redata)
#'
#' @export
#' @import stringr
#'
#'
cutpos <- function(dnaseq, enz, dataset = redata) {

    # select the enz in dataset, find recognition site
    site_seq <- toString(subset(dataset, name == enz, select = site)[1, 1])

    # convert recognition site to regular expression
    site_regex <- rs2regex(site_seq)

    # locate the cut position
    loc <- stringr::str_locate(dnaseq, site_regex)
    if (!any(is.na(loc))) {
        enz_name_seq <- data.frame(name = enz, seq = site_seq)
        result <- cbind(enz_name_seq, as.data.frame(loc))

        return(result)
    } else {
        return(NA)
    }
}


#' Convert recognition site to regular expression
#'
#'A helper function for \code{cutpos} to convert recognition site to regular expression.
#'
#'
#'@param rs a string of recognition site
#'
#'@return a string of regular expression
#'
#'@import seqinr
#'
rs2regex <- function(rs) {

    # convert rs string to rs vector
    rs_vec <- seqinr::s2c(rs)

    rexgex <- vector()
    for (b in rs_vec) {
        if ( (b != "_") & (b != "'") ) {
            temp <- switch(b, A = "A", C = "C", G = "G", T = "T",
                           r = "[AG]", y = "[CT]", m = "[AC]", k = "[GT]",
                           s = "[GC]", w = "[AT]", h = "[ATC]", b = "[GTC]",
                           v = "[GAC]", d = "[GAT]", n = "[ATCG]")
            rexgex <- c(rexgex, temp)
        }
    }
    return(seqinr::c2s(rexgex))
}

#' Remove invalid characters in DNA sequence
#'
#' Remove FASTA header and all letters except A, T, C, G.
#'
#'
#'@param s  chr DNA sequence, maybe not vaild
#'
#'@return chr a valid, uppercase, DNA sequence
#'
sanitizeSeq <- function(s) {

  s <- as.character(unlist(s))    # convert complex object to plain chr vector
  s <- unlist(strsplit(s, "\n"))  # split up at linebreaks, if any
  s <- s[! grepl("^>", s)]        # drop all lines beginning">" (FASTA header)
  s <- paste(s, collapse="")      # combine into single string
  s <- toupper(gsub("[^atcgATCG]", "", s))
  return(s)
}
