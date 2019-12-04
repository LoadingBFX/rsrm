#' Launch the shiny app for package rsrm
#'
#' A function that launches the shiny app for this package.
#' The code has been placed in \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a shiny page.
#'
#' @examples
#' \dontrun{
#' runRsrmApp()
#' }
#'
#' @export
#' @importFrom shiny runApp

runRsrmApp <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "rsrm")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}

# [END]
