# tests/test-create_survey_tables_and_ci.R

library(testthat)
library(dplyr)
library(survey)
library(surveyup)  # Assuming your package is named surveyup

# Example 1: Pre-pandemic 2017-2020 NHANES Data
nhanes_path <- "~/Desktop"  # Path to your NHANES data files
nhanes_files <- c("P_DEMO.XPT", "P_ALQ.XPT", "P_BIOPRO.XPT", "P_BMX.XPT", "P_BPQ.XPT", "P_CBC.XPT")

# Load NHANES data (ensure that load_nhanes_data is defined and works as expected)
nhanes_data <- load_nhanes_data(nhanes_path, nhanes_files)

# Define NHANES survey design object
nhanes_survey_design <- svydesign(
  data = nhanes_data,
  id = ~SDMVPSU,  # Primary sampling unit
  strata = ~SDMVSTRA,  # Stratum
  weights = ~WTINTPRP,  # Survey weights
  nest = TRUE
)


# Now you can test the function 'create_survey_tables_and_ci'

test_that("Test create_survey_tables_and_ci for NHANES data", {
  # Example of variables
  continuous_vars <- c("RIDAGEYR", "BMXBMI")  # Adjust to actual variables in your dataset
  categorical_vars <- c("RIAGENDR", "RIDRETH1")  # Adjust to actual variables in your dataset
  ci_vars <- c("RIAGENDR", "RIDRETH1")  # Adjust as needed

  # Call the function you are testing, assuming it works as intended
  result <- create_survey_tables_and_ci(
    continuous_vars = continuous_vars,
    categorical_vars = categorical_vars,
    ci_vars = ci_vars,
    survey_design = nhanes_survey_design
  )

})

