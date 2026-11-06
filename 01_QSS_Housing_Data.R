# install.packages("tidycensus")
# install.packages("tidyverse")

library(tidycensus)
library(tidyverse)

Sys.getenv("CENSUS_API_KEY")

# Data
VA_2005 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2005,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2006 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2006,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2007 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2007,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2008 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2008,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2009 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2009,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2010 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2010,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2011 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2011,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2012 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2012,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2013 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2013,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2014 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2014,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2015 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2015,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2016 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2016,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2017 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2017,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2018 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2018,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2019 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2019,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2021 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2021,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2022 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2022,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2023 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2023,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

VA_2024 <- get_acs(
  geography = "place",
  state = "VA",
  year = 2024,
  survey = "acs1",
  variables = c(median_home_value = "B25077_001"),
  geometry = FALSE)

# Merge
VA_2005 <- VA_2005 %>%
  mutate(year = 2005)

VA_2006 <- VA_2006 %>%
  mutate(year = 2006)

VA_2007 <- VA_2007 %>%
  mutate(year = 2007)

VA_2008 <- VA_2008 %>%
  mutate(year = 2008)

VA_2009 <- VA_2009 %>%
  mutate(year = 2009)

VA_2010 <- VA_2010 %>%
  mutate(year = 2010)

VA_2011 <- VA_2011 %>%
  mutate(year = 2011)

VA_2012 <- VA_2012 %>%
  mutate(year = 2012)

VA_2013 <- VA_2013 %>%
  mutate(year = 2013)

VA_2014 <- VA_2014 %>%
  mutate(year = 2014)

VA_2015 <- VA_2015 %>%
  mutate(year = 2015)

VA_2016 <- VA_2016 %>%
  mutate(year = 2016)

VA_2017 <- VA_2017 %>%
  mutate(year = 2017)

VA_2018 <- VA_2018 %>%
  mutate(year = 2018)

VA_2019 <- VA_2019 %>%
  mutate(year = 2019)

VA_2021 <- VA_2021 %>%
  mutate(year = 2021)

VA_2022 <- VA_2022 %>%
  mutate(year = 2022)

VA_2023 <- VA_2023 %>%
  mutate(year = 2023)

VA_2024 <- VA_2024 %>%
  mutate(year = 2024)

VA_Housing <- bind_rows(VA_2005, VA_2006, VA_2007, VA_2008, VA_2009, VA_2010, 
                        VA_2011, VA_2012, VA_2013, VA_2014, VA_2015, VA_2016,
                        VA_2017, VA_2018, VA_2019, VA_2021, VA_2022, VA_2023,
                        VA_2024)



