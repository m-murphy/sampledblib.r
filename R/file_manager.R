

#' Set Date Format
#' @description Set the date format string of the file parser
#'
#' @param date_format
#'
#' @return NULL
#' @export
set_date_format <- function(date_format) {
  file_manager <<- sampleDBLib$file_manager$CLIFileManager(date_format = date_format)
  message(sprintf("Using date format: %s", date_format))
}


#' Parse Plate Update Files
#' @description Parses files that are of the Plate Update format
#'
#' @param filepaths vector of file paths pointing to plate files to be processed
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @return returns list of matrix tube entries
#'
#' @details Matrix tube entries are named lists structured as:
#' ```
#'   matrix_tube_entry -> {
#'   'barcode': Unique tube barcode,
#'   'plate_uid': Unique Plate ID matrix tube is going into,
#'   'well_position': New matrix tube position,
#'   'comments': Optional comments
#'   }
#' ```
#'   This is useful for taking CSVs to update tube locations
#' @export
parse_plate_update_files <- function(filepaths, expand_path = FALSE) {
  if (expand_path) {
    filepaths = sapply(filepaths, path.expand)
  }
  file_manager$parse_plate_update_files(filepaths)
}


#' Parse Study Subject File
#' @description extracts the UID field from a Study Subject file
#'
#' @param filepath path to file
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @return returns vector of study subject UIDs
#' @export
parse_study_subject_file <- function(filepath, expand_path = FALSE) {
  if (expand_path) {
    filepath <- path.expand(filepath)
  }
  file_manager$parse_study_subject_file(filepath)
}


#' Parse New Plate File
#' @description Parses a file that satisfies the New Plate format
#'
#' @param filepath path to file
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @details A csv file is New Plate format if it contains the columns:
#'
#' | Well | Barcode | UID | Specimen Type | Study Short Code | Date (optional) | Comments (optional)|
#' | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
#' | ... | ... | ... | ... | ... | ... | ... |
#'
#' @return returns list of specimen entries with locations from file
#' @export
parse_new_plate_file <- function(filepath, expand_path = FALSE) {
  if (expand_path) {
    filepath <- path.expand(filepath)
  }
  file_manager$parse_new_plate_file(filepath)
}

#' Parse Specimen Search File
#' @description Parses a file that satisfies the Specimen Search format
#'
#' @param filepath path to file
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @details A csv file is Specimen Search format if it contains the columns:
#' | UID | Specimen Type | Study Short Code | Date (optional) |
#' | :---: | :---: | :---: | :---: |
#' | ... | ... | ... | ... |
#'
#' @return returns list of specimen entries
#' @export
parse_specimen_search_file <- function(filepath, expand_path = FALSE) {
  if (expand_path) {
    filepath <- path.expand(filepath)
  }
  file_manager$parse_specimen_search_file(filepath)
}

#' Parse Subject Search File
#' @description Parses a file that satisfies the Subject Search format
#'
#' @param filepath path to file
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @details A csv file is Specimen Search format if it contains the columns:
#' | UID | Study Short Code | Date (optional) |
#' | :---: | :---: | :---: | :---: |
#' | ... | ... | ... | ... |
#'
#' @return returns list of subject entries
#' @export
parse_subject_search_file <- function(filepath, expand_path = FALSE) {
  if (expand_path) {
    filepath <- path.expand(filepath)
  }
  file_manager$parse_subject_search_file(filepath)
}

#' Parse Barcode Search File
#' @description Parses a file that satisfies the Barcode Search format
#'
#' @param filepath path to file
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @details A csv file satisfies the Barcode Search format if it contains a column called "Barcode". This is useful for converting data where the barcode is known into fully expanded sample information.
#'
#'
#' @return a list containing a vector of barcode entries, the original fields of the data, and the index of the barcode column
#' @export
parse_barcode_search_file <- function(filepath, expand_path = FALSE) {
  if (expand_path) {
    filepath <- path.expand(filepath)
  }
  res <- file_manager$parse_barcode_search_file(filepath)
  parsed_res <- list(
    barcodes = res[[1]],
    fields = res[[2]],
    barcode_index = res[[3]]
  )
}

#' Parse Barcode File
#' @details Extracts the barcode column from a csv file
#'
#' @param filepath path to file
#' @param expand_path logical whether or not to expand a path from '~' to the
#'   fully qualified name
#'
#' @return Vector of barcodes in file
#' @export
parse_barcode_file <- function(filepath, expand_path = FALSE) {
  if (expand_path) {
    filepath <- path.expand(filepath)
  }

  file_manager$parse_barcode_file(filepath)
}
