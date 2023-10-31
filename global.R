library(tidyverse)
library(shiny)
library(magrittr)

################################################################################
# Example 1 - Static

# Load some data from the CS stats data browser
data_age <- read.csv("https://co-analysis.github.io/acses_data_browser_2023/Age/data.csv") %>%
  filter(Status=="In post") %>%
  mutate(across(any_of(c("Headcount","FTE","Mean_salary","Median_salary")),as.numeric))

################################################################################
# Example 4 - dynamic UI

# Get a list of available variables from the data browser meta data
cs_stats_vars <- read.csv("https://co-analysis.github.io/acses_data_browser_2023/metadata/var_values.csv") %>%
  pull(var) %>%
  unique() %>%
  setdiff(c("Status","Year"))
