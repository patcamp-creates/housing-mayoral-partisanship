
  
# import packages
library(tidyverse)
# install.packages("stargazer")
library(stargazer)

# load data
df <- read_csv("data/data.csv") %>%
  
  # drop columns
  select(-`...1`,
         -percent_change,
         -percent_change_1yr,
         -percent_change_2yr,
         -percent_change_4yr) %>%
  
  mutate(
    election_year = if_else(!is.na(pid_with_na), 1L, 0L)
  ) %>%
  
  rename(mayor_pid = pid_final_win) %>%
  
  distinct() %>%    # drop duplicates
  
  mutate(mayor_pid = as.factor(mayor_pid),
         city = as.factor(city),
         year = as.factor(year),
         abb = as.factor(abb)) %>%
  
  # calculate change in median_home_value into the future
  group_by(city) %>%
  mutate(
    party_change = if_else(is.na(lag(mayor_pid)), 0L,
                           as.integer(mayor_pid != lag(mayor_pid))),
    pct_1y = 100 * (lead(median_home_value, 1) - median_home_value) / median_home_value,
    pct_2y = 100 * (lead(median_home_value, 2) - median_home_value) / median_home_value,
    pct_3y = 100 * (lead(median_home_value, 3) - median_home_value) / median_home_value,
    pct_4y = 100 * (lead(median_home_value, 4) - median_home_value) / median_home_value,
    pct_5y = 100 * (lead(median_home_value, 5) - median_home_value) / median_home_value
  ) %>%
  select(-pid_with_na) %>%
  mutate(republican = ifelse(mayor_pid == "R", 1, 0))

reg_1y <- lm(pct_1y ~ republican + city + year, data = df)
summary(reg_1y)


reg_2y <- lm(pct_2y ~ republican + city + year, data = df)
summary(reg_2y)

reg_3y <- lm(pct_3y ~ republican + city + year, data = df)
summary(reg_3y)

reg_4y <- lm(pct_4y ~ republican + city + year, data = df)
summary(reg_4y)

reg_5y <- lm(pct_5y ~ republican + city + year, data = df)
summary(reg_5y)

# run install.packages("stargazer") if you haven't yet
stargazer(reg_1y, reg_2y, reg_3y, reg_4y, reg_5y, type = "text")


