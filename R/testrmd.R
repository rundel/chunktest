#' @export
init <- function(use_crayon = TRUE) {

  if (use_crayon) {
    options(crayon.enabled=TRUE)
    fansi::set_knit_hooks(knitr::knit_hooks)
  }
  
  knitr::knit_engines$set(testthat = testthat_engine)
}