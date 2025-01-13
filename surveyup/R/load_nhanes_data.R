#' Load and Merge Specific NHANES Datasets
#'
#' This function loads NHANES datasets from specified files and merges them by `SEQN`.
#' For downloading interested NHANES datasets, visit the official [CDC NHANES website](https://wwwn.cdc.gov/nchs/nhanes/).
#'
#' @param path A string specifying the directory containing the NHANES datasets.
#' @param files A character vector of file names to load and merge.
#' @return A data frame containing the merged datasets.
#' @importFrom haven read_xpt
#' @importFrom dplyr full_join
#' @examples
#' # Mac-specific example (assuming files are on the Desktop)
#' nhanes_path_mac <- "~/Desktop"
#' nhanes_files <- c("P_ALQ.XPT", "P_BIOPRO.XPT", "P_BMX.XPT", "P_BPQ.XPT", "P_CBC.XPT", "P_DEMO.XPT")
#' nhanes_data_mac <- load_nhanes_data(nhanes_path_mac, nhanes_files)
#'
#' # Non-Mac (Windows/Linux) specific example
#' nhanes_path_non_mac <- "C:/Users/YourName/Documents/nhanes_data"
#' nhanes_files_non_mac <- c("P_ALQ.XPT", "P_BIOPRO.XPT", "P_BMX.XPT", "P_BPQ.XPT", "P_CBC.XPT")
#' nhanes_data_non_mac <- load_nhanes_data(nhanes_path_non_mac, nhanes_files_non_mac)
#'
#' @export

load_nhanes_data <- function(path, files) {
  # Prepend the path to each file name to get the full file paths
  file_paths <- file.path(path, files)

  # Load data from each file and ensure they are data frames
  data <- lapply(file_paths, function(file) {
    df <- read_xpt(file) #haven package
    as.data.frame(df)
  })

  #Join datasets by SEQN
  merged_data <- Reduce(function(x, y) full_join(as.data.frame(x), as.data.frame(y), by = "SEQN"), data)

  return(merged_data)
}
