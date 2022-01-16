sampleDBLib = NULL
conn = NULL
file_manager = NULL

.onLoad <- function(libname, pkgname) {
  sampleDBLib <<- reticulate::import("sampledblib", delay_load = TRUE)

  conn_string <- getOption("sampledblib.db.location", "")
  date_format <- getOption("sampledblib.fm.dateformat", "%d-%b-%Y")

  if (conn_string == "") {
    packageStartupMessage("Database location has not been set, defaulting to in memory sqlite.")
    conn_string = "sqlite:///"
  } else {
    packageStartupMessage(sprintf("Loading database from %s", conn_string))
  }

  packageStartupMessage(sprintf("Using date format: %s", date_format))

  conn <<- sampleDBLib$app$SampleDB(conn_string)
  file_manager <<- sampleDBLib$file_manager$CLIFileManager(date_format = date_format)

}
