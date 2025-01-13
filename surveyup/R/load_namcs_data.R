#' Download, Unzip, and Read NAMCS Stata Data
#'
#' This function downloads the NAMCS Stata dataset for a specified year from the CDC FTP server,
#' unzips the file, and loads the data into an R dataframe. Optionally, the function can save the
#' data as a CSV file for further cleaning.
#' Zip files can be viewed here: [NAMCS Stata Datasets](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/dataset_documentation/namcs/stata/)
#'
#' @param year The year of the NAMCS dataset to download (e.g., 2009, 2018).
#' @param dest_dir The directory to save the downloaded zip file and unzip it (default is a temporary directory).
#' @param write_csv A logical value indicating whether to save the data as a CSV file (default is `FALSE`).
#'
#' @return A dataframe containing the NAMCS data for the specified year, read from the Stata file.
#' @details The function constructs a URL to download the NAMCS Stata dataset for the specified year,
#' unzips the downloaded file, and reads the Stata file into an R dataframe. If `write_csv` is `TRUE`,
#' the data is saved as a CSV file in the specified directory.
#'
#' @import haven
#' @import httr
#'
#' @examples
#' # Download and load the NAMCS 2018 dataset without writing to CSV
#' namcs2018 <- load_namcs_data(2018, write_csv = FALSE)
#'
#' # Download and load the NAMCS 2020 dataset and save as CSV
#' namcs2020 <- load_namcs_data(2009, write_csv = TRUE)
#'
#' @export
load_namcs_data <- function(year, dest_dir = tempdir(), write_csv = FALSE) {

  # Convert the year to character and make the whole string lowercase
  year <- tolower(as.character(year))

  # Construct URL based on the year (now in lowercase)
  url <- paste0("https://ftp.cdc.gov/pub/Health_Statistics/NCHS/dataset_documentation/namcs/stata/namcs", year, "-stata.zip")

  # Construct file paths (standardized to lowercase)
  zip_file <- file.path(dest_dir, paste0("namcs", year, "-stata.zip"))
  dta_file <- file.path(dest_dir, paste0("namcs", year, "-stata.dta"))

  # Download the zip file
  message("Downloading data for year ", year, "...")
  download.file(url, destfile = zip_file, mode = "wb")

  # Unzip the downloaded file
  message("Unzipping the file...")
  unzip(zip_file, exdir = dest_dir)

  # Read the Stata file
  message("Reading Stata file...")
  namcs_data <- read_dta(dta_file)

  # Optionally write the CSV for cleaning
  if (write_csv) {
    message("Writing data to CSV...")
    write.csv(namcs_data, file.path(dest_dir, paste0("namcs", year, ".csv")))
  }

  return(namcs_data)
}
