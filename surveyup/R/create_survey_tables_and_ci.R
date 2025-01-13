#' Generate Survey Summary Statistics
#'
#' Adding to the `survey` package, this function generates summary statistics
#' for continuous and categorical variables and computes 95% confidence intervals for specified variables.
#' The function supports both NHANES and NAMCS datasets with specific
#' variables for weights, strata, and primary sampling unit (PSU).
#'
#' @param continuous_vars A character vector of continuous variable names to include in the summary statistics.
#' @param categorical_vars A character vector of categorical variable names to include in the summary statistics.
#' @param ci_vars A character vector of variable names for which 95% confidence intervals should be calculated.
#' @param survey_design A survey design object created using the `survey` package.
#' @return A list containing the following elements:
#' \itemize{
#'   \item \code{continuous_summary}: A \code{svyCreateTableOne} object summarizing the continuous variables.
#'   \item \code{categorical_summary}: A \code{svyCreateCatTable} object summarizing the categorical variables.
#'   \item \code{confidence_intervals}: A data frame with 95% confidence intervals for the specified variables, including estimates, lower bounds, and upper bounds.
#' }
#' @importFrom tableone svyCreateTableOne
#' @importFrom tableone svyCreateCatTable
#' @importFrom survey svyciprop
#' @importFrom survey svydesign
#' @importFrom stats confint
#' @examples
#' # Example 1: Pre-pandemic 2017-2020 NHANES Data
#' nhanes_path <- "~/Desktop"
#' nhanes_files <- c("P_DEMO.XPT","P_ALQ.XPT", "P_BIOPRO.XPT", "P_BMX.XPT", "P_BPQ.XPT", "P_CBC.XPT")
#' nhanes_data <- load_nhanes_data(nhanes_path, nhanes_files)
#'
#' # Define NHANES survey design
#' nhanes_survey_design <- svydesign(
#'   data = nhanes_data,
#'   id = ~SDMVPSU,  # Primary sampling unit
#'   strata = ~SDMVSTRA,  # Stratum
#'   weights = ~WTINTPRP,  # Survey weights
#'   nest = TRUE
#' )
#'
#' # List out variables for NHANES - age, sex, BMI, and race variables
#' continuous_vars_nhanes <- c("RIDAGEYR", "BMXBMI")
#' categorical_vars_nhanes <- c("RIAGENDR", "RIDRETH1")
#' ci_vars_nhanes <- c("RIAGENDR", "RIDRETH1")
#'
#' # Generate results for NHANES
#' nhanes_results <- create_survey_tables_and_ci(
#'   continuous_vars = continuous_vars_nhanes,
#'   categorical_vars = categorical_vars_nhanes,
#'   ci_vars = ci_vars_nhanes,
#'   survey_design = nhanes_survey_design
#' )
#'
#' # Example 2: 2018 NAMCS Data
#' namcs_path <- "~/Desktop"
#' namcs_files <- c("namcs2018-stata.dta", "namcs2016-stata.dta")
#' namcs_data <- load_namcs_data(namcs_path, namcs_files)
#'
#' # Define NAMCS survey design
#' namcs_survey_design <- svydesign(
#'   data = namcs_data,
#'   id = ~PSU,  # Primary sampling unit
#'   strata = ~STRATUM,  # Stratum
#'   weights = ~WEIGHT,  # Survey weights
#'   nest = TRUE
#' )
#'
#' # List out variables for NAMCS - age, sex, BMI, and race variables
#' continuous_vars_namcs <- c("AGE", "BMI")
#' categorical_vars_namcs <- c("SEX", "RACERETH")
#' ci_vars_namcs <- c("SEX", "RACERETH")
#'
#' # Generate results for NAMCS
#' namcs_results <- create_survey_tables_and_ci(
#'   continuous_vars = continuous_vars_namcs,
#'   categorical_vars = categorical_vars_namcs,
#'   ci_vars = ci_vars_namcs,
#'   survey_design = namcs_survey_design
#' )
#'
#' @export

create_survey_tables_and_ci <- function(continuous_vars, categorical_vars, ci_vars, survey_design) {

  # Continuous variables table
  continuous_table <- svyCreateTableOne(vars = continuous_vars, data = survey_design, includeNA = TRUE)
  cat("Continuous Variable Summary:\n")
  print(summary(continuous_table))

  # Categorical variables table
  cat_table1 <- svyCreateCatTable(vars = categorical_vars, data = survey_design, includeNA = TRUE)
  cat("\nCategorical Variable Summary:\n")
  print(summary(cat_table1), showAllLevels = TRUE)

  # 95% Confidence Intervals
  cat("\n95% Confidence Intervals:\n")
  # Function to handle numeric, character, and factor variables
  ci_results <- do.call(rbind, lapply(ci_vars, function(var) {
    # Convert the variable to a character to handle both factor and character types
    var_data <- survey_design$variables[[var]]

    # Check if the variable is numeric, factor, or character
    if (is.factor(var_data) || is.character(var_data)) {
      unique_levels <- sort(unique(as.character(var_data)))  # Convert factor to character
    } else {
      unique_levels <- sort(unique(var_data))  # Handle numeric categories
    }

    # Calculate CI for each level (whether numeric or character)
    ci_per_level <- do.call(rbind, lapply(unique_levels, function(level) {
      # Create a condition based on the level (safely create formula)
      ci_formula <- as.formula(paste0("~I(", var, " == '", level, "')"))

      # Calculate CI
      ci <- svyciprop(ci_formula, survey_design, method = "lo", level = 0.95)

      # Return CI results in a dataframe
      ci_result <- data.frame(
        Variable = var,
        Level = level,
        Estimate = coef(ci),
        CI_Lower = confint(ci)[1],
        CI_Upper = confint(ci)[2]
      )
      return(ci_result)
    }))

    return(ci_per_level)
  }))

  # Print the combined confidence intervals
  print(ci_results)

  # Return all results as a list, with confidence intervals in a single dataframe
  return(list(
    continuous_summary = continuous_table,
    categorical_summary = cat_table1,
    confidence_intervals = ci_results
  ))
}
