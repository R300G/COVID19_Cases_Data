#### Preamble ####
# Purpose: Clean the survey data downloaded from https://open.toronto.ca/dataset/covid-19-cases-in-toronto/
# Author: Charles Lu
# Data: 3 Feb 2021
# Contact: charlesjiahong.lu@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)
# Read in the raw data.
covid19_cases <- readr::read_csv("inputs/data/COVID19_cases.csv")

# clean variable names and select the variables I decided to use
cleaned_covid19_cases <-
  covid19_cases %>%
  clean_names() %>%
  select(
    age_group, source_of_infection, episode_date, client_gender,
    ever_hospitalized, ever_in_icu, ever_intubated
  )%>% dplyr::rename(infected_date = episode_date,gender=client_gender)
# added a new column named severity using the information from ever_hospitalized, ever_in_icu, ever_intubated, and removed the 3 columns
cleaned_covid19_cases <- cleaned_covid19_cases %>%
  mutate(severity = ifelse(ever_intubated == "Yes", "intubated",
    ifelse(ever_in_icu == "Yes", "in_icu",
      ifelse(ever_hospitalized == "Yes", "hospitalized", "not_hospitalized")
    )
  )) %>%
  select(-c(ever_hospitalized, ever_in_icu, ever_intubated))
#sort levels in severity
cleaned_covid19_cases$severity <- factor(cleaned_covid19_cases$severity, levels = c("intubated","in_icu","hospitalized","not_hospitalized"))
write_csv(x=cleaned_covid19_cases, file = "inputs/data/cleaned_covid19_cases.csv")


