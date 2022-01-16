sampleDBLib = NULL

.onLoad <- function(libname, pkgname) {
  sampleDBLib <<- reticulate::import("sampledblib", delay_load = TRUE)
}
