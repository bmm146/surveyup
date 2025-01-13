# tests/test-load_namcs_data.R

library(surveyup)
# Download and load the NAMCS 2018 dataset without writing to CSV
namcs2018 <- load_namcs_data(2018, write_csv = FALSE)

