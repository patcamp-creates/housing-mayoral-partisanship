library(dplyr)
library(stringr)
library(tidyr)

# Merge
Housing_All <- Housing %>%
  mutate(
    state = sub(".*, ", "", NAME),
    city  = sub(" city.*| town.*| municipality.*", "", NAME))

# Clean up variable types for merge
election_data_kessner <- election_data_kessner %>%
  mutate(
    place_fips = str_pad(as.character(place_fips), width = 7, pad = "0"))

Housing_All <- Housing_All %>%
  mutate(
    GEOID = str_pad(as.character(GEOID), width = 7, pad = "0"))

# Merge data
Merged_Data_Full <- election_data_kessner %>%
  left_join(
    Housing_All,
    by = c("year" = "year", "place_fips" = "GEOID"))

Merged_Data_Full <- Merged_Data_Full %>%
  select(
    place_fips, year, city = city.y, abb, pid_final_win,
    dem_elected, rep_elected, median_home_value = estimate,
    moe)

Merged_Data_Full_2005_On <- Merged_Data_Full %>%
  filter(year >= 2005) %>%
  arrange(place_fips, year)

# Remove cities that don't switch partisanship within 15 year window
Merge_Data_CLean <- Merge_Data_CLean %>%
  arrange(place_fips, year)

Merge_Data_CLean <- Merge_Data_CLean %>%
  filter(place_fips != "0627000", year <= 2019)

cities_with_switch <- Merged_Data_Full_2005_On %>%
  filter(pid_final_win %in% c("D", "R")) %>%   # ignore NA years
  group_by(place_fips, city, abb) %>%
  summarise(
    parties = n_distinct(pid_final_win),
    .groups = "drop") %>%
  filter(parties > 1)


Merge_Data_Switches <- Merge_Data_CLean %>%
  filter(city %in% c("Mobile", "Montgomery", "Anchorage", "Flagstaff", 
                     "Phoenix","Surprise", "Tempe", "Tucson", "Alameda",
                     "Antioch", "Carlsbad", "Chula Vista", "Escondido", 
                     "Fontana", "Garden Grove", "Irvine", "Lancaster",
                     "Long Beach", "Milpitas", "Modesto", "Perris",
                     "Pleasanton", "Rancho Cucamonga", "Rialto",
                     "Salinas", "San Bernardino", "San Diego", "Santa Barbara",
                     "Stockton", "Torrance", "Fort Collins", "Greeley",
                     "Longmont", "Norwalk", "Stamford", "Cape Coral",
                     "Coral Springs", "Davie", "Gainesville", "Jacksonville",
                     "Lakeland", "Miami", "Miami Beach", "Port St. Lucie", 
                     "St. Petersburg", "Savannah", "Aurora", "Bloomington",
                     "Champaign", "Peoria", "Evansville", "Springfield", 
                     "Topeka", "Wichita", "Frederick", "Lawrence", "Lynn",
                     "Farmington Hills", "Sterling Heights", "Troy", "Columbia",
                     "Springfield", "New York", "Yonkers", "Charlotte", 
                     "Concord", "Fayetteville", "Greensboro", "High Point",
                     "Dayton", "Toledo", "Hillsboro", "Salem", "Cranston", 
                     "Warwick", "Clarksville", "Knoxville", "Murfreesboro",
                     "Ogden", "Sandy"))


Merge_Data_Switches <- Merge_Data_Switches %>%
  filter(year <= 2019)

# Replace NAs with D or R
Merge_Data_Switches <- Merge_Data_Switches %>%
  arrange(place_fips, year) %>%
  group_by(place_fips) %>%
  fill(pid_final_win, .direction = "downup") %>%
  ungroup()

Merge_Data_Switches <- Merge_Data_Switches %>%
  select(place_fips,year,city,abb,pid_final_win,
         median_home_value,moe)

# Add columns
pid_column <- Merge_Data_CLean %>%
  select(pid_final_win, place_fips, year) %>%
  rename(pid_with_na = pid_final_win)

Merge_Data_Switches <- Merge_Data_Switches %>%
  left_join(pid_column, by = c("place_fips", "year"))

Merge_Data_Switches <- Merge_Data_Switches %>%
  select(place_fips,year,city,abb,pid_final_win,pid_with_na,
         median_home_value, moe)


# Add Percent Change columns
Merge_Data_Switches <- Merge_Data_Switches %>%
  arrange(place_fips, year) %>%
  group_by(place_fips) %>%
  mutate(
    percent_change_1yr = (median_home_value / lag(median_home_value, 1) - 1) * 100,
    percent_change_2yr = (median_home_value / lag(median_home_value, 2) - 1) * 100,
    percent_change_4yr = (median_home_value / lag(median_home_value, 4) - 1) * 100
  ) %>%
  ungroup()

Merge_Data_Switches <- Merge_Data_Switches %>%
  mutate(
    percent_change_1yr = replace_na(percent_change_1yr, 0),
    percent_change_2yr = replace_na(percent_change_2yr, 0),
    percent_change_4yr = replace_na(percent_change_4yr, 0))

CA_NY_FL <- Merge_Data_Switches %>%
  filter(abb %in% c("CA", "NY", "FL"))
