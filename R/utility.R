#' Find the position cut by given enzyme
#'
#' @param dnaSeq a string of DNA sequence
#' @param enz the name of enzyme
#' @param dataset the data used to store enzyme info
#'
#' @return a matrix of cut position
#'
#' @import stringr
#'
#'
cutpos <- function(dnaSeq, enz, dataset = redata) {

  #sel enz in dataset, find recognition site
  siteSeq <- toString(subset(dataset, name == enz, select = site)[1,1])

  #convert recognition site to regular expression
  site_regex <- rs2regex(siteSeq)

  #locate the cut position
  loc <- stringr::str_locate(dnaSeq, site_regex)
  if(!any(is.na(loc))){
    enz_col <- matrix(enz, nrow = nrow(loc))
    result <- cbind(enz_col, loc)
    return(result)
  } else {
    return(NA)
  }
}


#' convert recognition site to regular expression
#'
#'
#'
#'
#'@param rs a string of recognition site
#'
#'@return a string of regex
#'
#'@import seqinr
#'
rs2regex <- function(rs) {

  # convert rs string to rs vector
  rs_vec <- seqinr::s2c(rs)

  rexgex <- vector()
  for (b in rs_vec) {
    if ((b != '_') & (b != "'")) {
      temp <- switch(b,
                     A = 'A', C = 'C', G = 'G', T = 'T',
                     r = 'A|G', y = 'C|T', m = 'A|C', k = 'G|T',
                     s = 'G|C', w = 'A|T', h = '[ATC]', b = '[GTC]',
                     v = '[GAC]', d = '[GAT]', n = '[ATCG]'
                     )
      rexgex <- c(rexgex, temp)
    }
  }
  return(seqinr::c2s(rexgex))
}


