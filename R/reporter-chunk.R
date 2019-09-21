#' Chunk reporter: 
#'
#' A version of a reporter that is suitable for reporting the results of testthat tests
#' that are contained in an `knitr` chunk.
#'
#' @export

ChunkReporter <- R6::R6Class(
  "ChunkReporter",
  inherit = testthat::Reporter,
  public = list(
    failures = list(),
    n_ok = 0L,
    n_skip = 0L,
    n_fail = 0L,
    n_warn = 0L,
    
    initialize = function(...) {
      super$initialize(...)
    },
    
    add_result = function(context, test, result) {
      if (testthat:::expectation_skip(result)) {
        self$n_skip <- self$n_skip + 1L
        return()
      }
      if (testthat:::expectation_warning(result)) {
        self$n_warn <- self$n_warn + 1L
        return()
      }
      if (testthat:::expectation_ok(result)) {
        self$n_ok <- self$n_ok + 1L
        return()
      }
      
      self$n_fail <- self$n_fail + 1L
      self$failures[[self$n_fail]] <- result
      
      self$cat_line(failure_summary(result, self$n_fail))
      self$cat_line()
    },
    
    end_reporter = function() {
      self$rule("Results", line = 2)
      self$cat_line(
        "[ ",
        "Ok: ", self$n_ok, " | ",
        "Skipped: ", self$n_skip, " | ",
        "Warnings: ", self$n_warn, " | ",
        "Failed: ", self$n_fail,
        " ]"
      )
    }
  )
)


skip_summary <- function(x, label) {
  header <- paste0(label, ". ", x$test)
  
  paste0(
    colourise(header, "skip"), src_loc(x$srcref), " - ", x$message
  )
}

failure_summary <- function(x, label, width = cli::console_width()) {
  header <- paste0(label, ". ", failure_header(x))
  paste0(
    cli::rule(header, col = testthat:::testthat_style("error")), "\n",
    format_expectation_error(x)
  )
}

format_expectation_error = function (x, ...) 
{
  msg = x$message
  msg = gsub("(^|\n)", "\\1  ", msg)
    
  paste(c(msg), collapse = "\n")
}



failure_header <- function(x) {
  type <- switch(testthat:::expectation_type(x),
                 error = "Error",
                 failure = "Failure"
  )
  
  paste0(type, ": ", x$test, src_loc(x$srcref), " ")
}

src_loc <- function(ref) {
  if (is.null(ref)) {
    ""
  } else {
    paste0(" (@", basename(attr(ref, "srcfile")$filename), "#", ref[1], ")")
  }
}
