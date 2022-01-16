internal <- new.env()
assign("conn", NULL, envir=internal)
assign("file_manager", NULL, envir=internal)

#' Install SampleDBLib
#'
#' @return
#' @export
install_sampledblib <- function(force = FALSE) {
  if(!reticulate::py_module_available("sampledblib") | force) {
    reticulate::py_install("git+https://github.com/m-murphy/sampledblib@dev")
  } else {
    message("sampledblib already installed.")
  }
}

#' Initialize SampleDB
#'
#' @return
#' @export
initialize_sampledb <- function(conn_string = getOption("sampledblib.db.location", ""),
                                date_format = getOption("sampledblib.fm.dateformat", "%d-%b-%Y")
                                ) {

  if (conn_string == "") {
    message("Database location has not been set, defaulting to in memory sqlite.")
    conn_string = "sqlite:///"
  } else {
    message(sprintf("Loading database from %s", conn_string))
  }

  message(sprintf("Using date format: %s", date_format))
  assign("conn", sampleDBLib$app$SampleDB(conn_string), envir=internal)
  assign("file_manager", sampleDBLib$file_manager$CLIFileManager(date_format = date_format), envir=internal)
}


#' Create Study
#' @description Create a new study entry in the database. Throws a ValueError if
#'   the short_code is not unique
#'
#' @param title the title of the study
#' @param short_code a short unique string that is used to refer to the study
#' @param is_longitudinal logical indicating if the study is a longitudinal
#'   study. Setting this value will result in extra logical checks when adding
#'   samples to ensure they have collection dates associated
#' @param lead_person the person responsible for the study samples
#' @param description an optional field to give more context to the study
#'
#' @return returns the study object created
#' @export
create_study <- function(title, short_code, is_longitudinal, lead_person, description = NULL) {
  conn <- get("conn", envir=internal)
  conn$create_study(title, short_code, is_longitudinal, lead_person, description)
}


#' Get study
#'
#' @param id id of the study
#'
#' @return returns list containing the study, its subjects, specimens, and their
#'   containers
#' @export
get_study <- function(id) {
  conn <- get("conn", envir=internal)
  res <- conn$get_study(id)

  processed_res <- list(
    study = res[[1]],
    subjects = res[[2]],
    specimens = res[[3]],
    containers = res[[4]]
  )

  return(processed_res)
}


#' Get all studies
#'
#' @return returns the list of all studies
#' @export
get_studies <- function() {
  conn <- get("conn", envir=internal)
  conn$get_studies()
}


#' Get study by short code
#'
#' @param short_code unique short code that is used by the study
#'
#' @return returns the study with the short code
#' @export
get_study_by_short_code <- function(short_code) {
  conn <- get("conn", envir=internal)
  conn$get_study_by_short_code(short_code)
}


#' Update Study
#'
#' @param study_id integer ID of study to update
#' @param d named list containing fields to update
#'
#' @return returns the updated study, its subjects, specimens, and their
#'   containers
#' @export
#'
#' @examples
#' update_study(1, list(title = "My new title"))
update_study <- function(study_id, d) {
  conn <- get("conn", envir=internal)

  res <- conn$update_study(study_id, d)

  processed_res <- list(
    study = res[[1]],
    subjects = res[[2]],
    specimens = res[[3]],
    containers = res[[4]]
  )

  return(processed_res)
}


#' Delete study by ID
#'
#' @description Delete study by ID. Deletion will delete all samples and storage
#'   containers associated.
#'
#' @param study_id integer ID of study to delete
#'
#' @return returns TRUE if the study was deleted
#' @export
delete_study_by_id <- function(study_id) {
  conn <- get("conn", envir=internal)

  conn$delete_study_by_id(study_id)
}


#' Get Study Subjects
#'
#' @description Get study subjects associated with provided study ID
#'
#' @param id integer ID of study to search
#'
#' @return returns list of study subjects in study
#' @export
get_study_subjects <- function(id) {
  conn <- get("conn", envir=internal)

  conn$get_study_subjects(id)
}


#' Add study subject
#'
#' @param uid Unique identifier of study subject to be added to study
#' @param study_id integer ID of study to add study subject to
#'
#' @return returns added study subject
#' @export
add_study_subject <- function(uid, study_id) {
  conn <- get("conn", envir=internal)

  conn$add_study_subject(uid, study_id)
}


#' Add study subjects
#'
#' @param uids vector of unique identifiers of study subjects to be added to
#'   study
#' @param study_id integer ID of study to add study subjects to
#'
#' @return returns list of added study subjects
#' @export
add_study_subjects <- function(uids, study_id) {
  conn <- get("conn", envir=internal)

  conn$add_study_subjects(uids, study_id)
}


#' Delete study subject
#'
#' @description Cannot delete study subjects that have specimens associated in
#'   the database.
#'
#' @param study_subject_id  integer ID of study subject to delete
#'
#' @return returns TRUE if study subject is deleted. Raises NoResultFound if
#'   study_subject_id does not match a study subject. Raises ValueError if there
#'   are specimens associated with the sample.
#' @export
delete_study_subject <- function(study_subject_id) {
  conn <- get("conn", envir=internal)

  conn$delete_study_subject(id)
}


#' Get Locations
#'
#' @return list of all locations
#' @export
get_locations <- function() {
  conn <- get("conn", envir=internal)

  conn$get_locations()
}


#' Get Location
#'
#' @param location_id integer ID of location to get
#'
#' @return Location entry
#' @export
#'
get_location <- function(location_id) {
  conn <- get("conn", envir=internal)

  conn$get_location(location_id)
}


#' Create Location
#' @description Register a new storage location
#'
#' @param description short unique string that describes the location
#'
#' @return Location entry
#' @export
#'
create_location <- function(description) {
  conn <- get("conn", envir=internal)

  conn$register_new_location(description)
}


#' Update Location
#'
#' @param location_id integer ID of the location to update
#' @param d named list containing fields to update
#'
#' @return Updated location entry
#' @export
#'
update_location <- function(location_id, d) {
  conn <- get("conn", envir=internal)

  conn$update_location(location_id, d)
}


#' Delete Location
#'
#' @description Cannot delete locations with storage containers associated.
#'
#' @param location_id  integer ID of the location to delete
#'
#' @return Returns TRUE if the location is succesfully deleted. Raises a
#'   ValueError if there are storage containers associated with the location.
#' @export
delete_location <- function(location_id) {
  conn <- get("conn", envir=internal)

  conn$delete_location(location_id)
}


#' Create Specimen Type
#'
#' @param label unique description of the specimen type
#'
#' @return returns the created specimen type
#' @export
create_specimen_type <- function(label) {
  conn <- get("conn", envir=internal)

  conn$register_new_specimen_type(label)
}

#' Get Specimen Types
#'
#' @return returns the list of all specimen types
#' @export
get_specimen_types <- function() {
  conn <- get("conn", envir=internal)

  conn$get_specimen_types()
}

#' Get Specimen Type
#'
#' @param specimen_type_id integer ID of the specimen type
#'
#' @return returns the specimen type with ID
#' @export
get_specimen_type <- function(specimen_type_id) {
  conn <- get("conn", envir=internal)

  conn$get_specimen_type(specimen_type_id)
}

#' Update Specimen Type
#'
#' @param specimen_type_id integer ID of the specimen type to update
#' @param d named list of fields to update
#'
#' @return returns the updated specimen type
#' @export
update_specimen_type <- function(specimen_type_id, d) {
  conn <- get("conn", envir=internal)

  conn$update_specimen_type(specimen_type_id, d)
}

#' Delete Specimen Type
#'
#' @param specimen_type_id integer ID of the specimen type to delete
#'
#' @return returns TRUE if the type is successfully deleted. Raises ValueError
#'   if the type has specimens associated.
#' @export
delete_specimen_type <- function(specimen_type_id) {
  conn <- get("conn", envir=internal)

  conn$delete_specimen_type(specimen_type_id)
}

#' Get Specimens
#'
#' @description Get specimens associated with a sample
#'
#' @param uid unique identifier for a sample within a study
#' @param short_code unique short code identifying the study
#' @param collection_date optional collection date
#'
#' @return list of Specimens
#' @export
get_specimens <- function(uid, short_code, collection_date = NULL) {
  conn <- get("conn", envir=internal)

  conn$get_specimens(uid, short_code, collection_date)
}

#' Get Matrix Plates
#'
#' @return list of Matrix Plates
#' @export
get_matrix_plates <- function() {
  conn <- get("conn", envir=internal)

  conn$get_matrix_plates()
}

#' Get Matrix Plate
#'
#' @description Get a matrix plate along with its associated study subjects,
#'   specimens, and tubes
#'
#' @param plate_id integer ID of the matrix plate
#'
#' @return returns the matrix plate, its study subjects, specimens, and tubes
#' @export
get_matrix_plate <- function(plate_id) {
  conn <- get("conn", envir=internal)

  res <- conn$get_matrix_plate(plate_id)
  processed_res <- list(
    plate = res[[1]],
    study_subjects = res[[2]],
    specimens = res[[3]],
    tubes = res[[4]]
  )
  return(processed_res)
}

#' Add Matrix Plate with Specimens
#'
#' @description Find or else create a matrix plate with plate_uid.
#'
#' @param plate_uid unique identifier for matrix plate
#' @param location_id integer ID for plate location
#' @param specimen_entries list of specimen entries
#' @param create_missing_specimens Logical whether or not to create missing
#'   specimens
#' @param create_missing_subjects Logical whether or not to create missing study
#'   subjects
#'
#' @return returns the matrix plate, its study subjects, specimens, and tubes
#'
#' @details Specimen entries are named lists structured as:
#' ```
#' specimen_entry -> {
#'   'uid': Unique study subject ID,
#'   'short_code': Unique study short code,
#'   'specimen_type': String descriptor of specimen, must be registered,
#'   'collection_date': Optional date of collection,
#'   'barcode': Matrix tube barcode,
#'   'well_position': Well position in plate,
#'   'comments': Optional comments about matrix tube
#' }
#' ```
#'   specimen entries should be created from a CSV
#'
#' @export
add_matrix_plate_with_specimens <- function(plate_uid, location_id, specimen_entries, create_missing_specimens = FALSE, create_missing_subjects = FALSE) {
  conn <- get("conn", envir=internal)

  res <- conn$add_matrix_plate_with_specimens(plate_uid, location_id, specimen_entries, create_missing_specimens, create_missing_subjects)
  processed_res <- list(
    plate = res[[1]],
    study_subjects = res[[2]],
    specimens = res[[3]],
    tubes = res[[4]]
  )
  return(processed_res)
}

#' Update matrix tube locations
#'
#' @param matrix_tube_entries  list of matrix tube entries
#'
#' @details Matrix tube entries are named lists structured as:
#' ```
#' matrix_tube_entry -> {
#'  'barcode': Unique tube barcode,
#'  'plate_uid': Unique Plate ID matrix tube is going into,
#'  'well_position': New matrix tube position,
#'  'comments': Optional comments }
#' ```
#'   matrix tube entries should be created from a CSV
#'
#' @return returns named list containing updated matrix plates, their study
#'   subjects, specimens, and tubes
#' @export
update_matrix_tube_locations <- function(matrix_tube_entries) {
  conn <- get("conn", envir=internal)

  res <- conn$update_matrix_tube_locations(matrix_tube_entries)
  processed_res <- list(
    plates = res[[1]],
    study_subjects = res[[2]],
    specimens = res[[3]],
    tubes = res[[4]]
  )
  return(processed_res)
}

#' Delete Plate
#'
#' @param plate_id integer ID of the plate to be deleted
#'
#' @return returns TRUE if the plate is succesfully deleted. Raises ValueError
#'   if the plate contains tubes
#' @export
delete_plate <- function(plate_id) {
  conn <- get("conn", envir=internal)

  conn$delete_plate(plate_id)
}

#' Find Specimens
#'
#' @param specimen_entries list of specimen entries to search for
#' @param date_format optional date formatting string for output
#'
#' @return list of specimens and their locations
#'
#' @details Specimen entries are named lists structured as:
#' ```
#' specimen_entry -> {
#'   'uid': Unique study subject ID,
#'   'short_code': Unique study short code,
#'   'specimen_type': String descriptor of specimen, must be registered,
#'   'collection_date': Optional date of collection,
#' }
#' ```
#'   specimen entries should be created from a CSV
#'
#' @export
find_specimens <- function(specimen_entries, date_format = getOption("sampledblib.dateformat", "%d/%m/%Y")) {
  conn <- get("conn", envir=internal)

  conn$find_specimens(specimen_entries, date_format)
}


#' Get Matrix Tubes from Specimens
#'
#' @param specimen_entries list of specimen entries to search for
#'
#' @return returns list of matrix tubes for specimens
#'
#' @details Specimen entries are named lists structured as:
#' ```
#' specimen_entry -> {
#'   'uid': Unique study subject ID,
#'   'short_code': Unique study short code,
#'   'specimen_type': String descriptor of specimen, must be registered,
#'   'collection_date': Optional date of collection,
#' }
#' ```
#'   specimen entries should be created from a CSV
#'
#' @export
get_matrix_tubes_from_specimens <- function(specimen_entries) {
  conn <- get("conn", envir=internal)

  conn$get_matrix_tubes_from_specimens(specimen_entries)
}

#' Get Matrix Tube
#'
#' @param barcode matrix tube barcode
#'
#' @return returns the matrix tube with barcode
#' @export
get_matrix_tube <- function(barcode) {
  conn <- get("conn", envir=internal)

  conn$get_matrix_tube(barcode)
}

#' Get Matrix Tubes
#'
#' @param barcodes vector of matrix tube barcodes
#'
#' @return returns list of matrix tubes with provided barcodes
#' @export
get_matrix_tubes <- function(barcodes) {
  conn <- get("conn", envir=internal)

  conn$get_matrix_tubes(barcodes)
}


#' Set Matrix Tubes Exhausted
#'
#' @param barcodes vector of matrix tube barcodes to set exhausted
#'
#' @return returns list of matrix tubes that have been set exhausted
#' @export
set_matrix_tubes_exhausted <- function(barcodes) {
  conn <- get("conn", envir=internal)

  conn$set_matrix_tubes_exhausted(barcodes)
}



#' Unset Matrix Tubes Exhausted
#'
#' @param barcodes vector of matrix tube barcodes to unset exhausted
#'
#' @return returns list of matrix tubes that have been unset exhausted
#' @export
unset_matrix_tubes_exhausted <- function(barcodes) {
  conn <- get("conn", envir=internal)

  conn$unset_matrix_tubes_exhausted(barcodes)
}

#' Delete Matrix Tubes and Specimens
#' @description Simultaneously delete matrix tubes and specimens. This is
#'   necessary to delete specimens, otherwise there will be logical errors.
#'
#' @param matrix_tubes List of matrix tubes to be deleted
#' @param specimens List of specimens to be deleted
#'
#' @return returns the IDs of deleted matrix tubes and specimens
#' @export
delete_matrix_tubes_and_specimens <- function(matrix_tubes, specimens) {
  conn <- get("conn", envir=internal)

  conn$delete_matrix_tubes_and_specimens(matrix_tubes, specimens)
}

#' Delete Matrix Tubes
#' @description Delete matrix tubes and any associated specimens that now do not
#'   have any storage containers associated
#'
#' @param matrix_tubes List of matrix tubes to be deleted
#'
#' @return
#' @export
delete_matrix_tubes <- function(matrix_tubes) {
  conn <- get("conn", envir=internal)

  conn$delete_matrix_tubes(matrix_tubes)
}
