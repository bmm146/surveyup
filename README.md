# surveyup R package
Authors:

Bridget M. Mayrer, MS

Ravy Vajravelu, MD, MSCE

## Overview
The `surveyup` package is an extension of the `survey` R package for analyses on weighted survey data. The package provies functions for easy summarization of weighted categorical and continuous variables. The package supports weighted data from [NAMCS](https://www.cdc.gov/nchs/namcs/documentation/index.html) and [NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) data. 

## Functions
This package includes the following key functions:

**load_nhanes_data**: Loads NHANES data from specified file paths and combines them into a single dataframe for analysis.

**load_namcs_data**: Loads NAMCS data directly from NAMCS and merges the datasets for use in survey analysis.

**create_survey_tables_and_ci**: Generates survey tables with confidence intervals for continuous and categorical variables, facilitating weighted survey analysis.
