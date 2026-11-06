install.packages("tidycensus")
install.packages("tidyverse")

library(tidycensus)
library(tidyverse)

census_api_key((Sys.getenv("CENSUS_API_KEY")), install = TRUE)

# Data
states <- c("AK","AL","AR","AZ","CA","CO","CT","FL","GA","IL","IN","KS",
            "MA","MD","MI","MN","MO","NC","NJ","NY","OH","OR","PA","RI",
            "SC","TN","UT","VA")

years <- setdiff(2005:2024, 2020)

# Every state/year combination
params <- expand_grid(state = states, year = years)

safe_get_acs <- possibly(get_acs, otherwise = NULL)

Housing <- params %>%
  pmap_dfr(function(state, year) {
    safe_get_acs(
      geography = "place",
      state     = state,
      year      = year,
      survey    = "acs1",
      variables = c(median_home_value = "B25077_001")
    ) %>%
      mutate(year = year, state = state)
  })

