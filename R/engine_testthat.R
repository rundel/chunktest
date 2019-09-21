local_tempfile = function (new, name, envir = parent.frame(), tmpdir = tempdir()) {
  file = file.path(tmpdir,name)
  
  if (file.exists(file))
    stop("Temporary file with that name already exists in ", tmpdir, call. = FALSE)
  
  file.create(file)
  
  if (!file.exists(file))
    stop("Failed to create file ", name, " in ", tmpdir, call. = FALSE)
  
  assign(new, file, envir = envir)
  withr::defer(unlink(mget(new, envir = envir)), envir = envir)
}


testthat_engine = function(options) {
  local_tempfile("source_file", options$label)
  writeLines(options$code, source_file)
  test_env = new.env(parent = knitr::knit_global())
  
  if (is.null(options$reporter)) {
    options$reporter = ChunkReporter
  }
  
  if (options$eval) {
    message("Running testthat")
    withr::local_options(list(cli.width = 100))
    output = capture.output(
      testthat::test_file(source_file, reporter = options$reporter$new(file = stdout()), env = test_env())
    )
    message("Finished testthat")
  }
  options$engine = "r"
  knitr::engine_output(options, options$code, output)
}