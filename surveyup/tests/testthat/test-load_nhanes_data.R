library(surveyup)
# Mac-specific example (assuming files are on the Desktop)
nhanes_path_mac <- "~/Desktop"
nhanes_files <- c("P_ALQ.XPT", "P_BIOPRO.XPT", "P_BMX.XPT", "P_BPQ.XPT", "P_CBC.XPT", "P_DEMO.XPT")
nhanes_data_mac <- load_nhanes_data(nhanes_path_mac, nhanes_files)
