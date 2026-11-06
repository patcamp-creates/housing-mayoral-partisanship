library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

# Create Visualizations
str(Merge_Data_Switches)


summary_table <- Merge_Data_Switches %>%
  summarise(
    Observations = n(),
    Cities = n_distinct(city))

summary_table_long <- summary_table %>%
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Value")

mobile_summary_long <- Merge_Data_Switches %>%
  filter(city == "Mobile") %>%
  summarise(
    Observations = n(),
    Median_Home_Value_Mean = mean(median_home_value, na.rm = TRUE),
    Percent_Change_Mean = mean(percent_change, na.rm = TRUE)) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Value") %>%
  mutate(Value = round(Value, 1))

# Bar Plots 

# Mobile
mobile_data <- Merge_Data_Switches %>%
  filter(place_fips == "0150000")

ggplot(mobile_data, aes(x = factor(year),
                        y = median_home_value,
                        fill = pid_final_win)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("D" = "blue", "R" = "red")) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Median Home Value in Mobile by Year",
    x = "Year",
    y = "Median Home Value",
    fill = "Mayor Party") +
  theme_minimal()

# Torrance 
torrance_data <- Merge_Data_Switches %>%
  filter(place_fips == "0680000")

ggplot(torrance_data, aes(x = factor(year),
                        y = median_home_value,
                        fill = pid_final_win)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("D" = "blue", "R" = "red")) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Median Home Value in Torrance by Year",
    x = "Year",
    y = "Median Home Value",
    fill = "Mayor Party") +
  theme_minimal()
