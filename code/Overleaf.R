# Packages
library(tidyverse)
library(stargazer)
library(ggplot2)
library(sandwich)
library(lmtest)

# 0) Folders (Overleaf structure)
dir.create("tables",  showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# 1) Load + clean (match your existing workflow)
df <- read_csv("data/data.csv") %>%
  select(-`...1`,
         -percent_change,
         -percent_change_1yr,
         -percent_change_2yr,
         -percent_change_4yr) %>%
  mutate(election_year = if_else(!is.na(pid_with_na), 1L, 0L)) %>%
  rename(mayor_pid = pid_final_win) %>%
  distinct() %>%
  arrange(city, year) %>%
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
  ungroup() %>%
  select(-pid_with_na) %>%
  mutate(
    republican = if_else(mayor_pid == "R", 1, 0),
    city = as.factor(city),
    year = as.factor(year)
  )

# 2) Summary statistics table -> output/tables/summary_stats.tex
# Keep it simple and readable: key variables only
summ_df <- df %>%
  transmute(
    median_home_value = median_home_value,
    republican = republican,
    pct_1y = pct_1y,
    pct_2y = pct_2y,
    pct_3y = pct_3y,
    pct_4y = pct_4y,
    pct_5y = pct_5y
  )

summ_df <- summ_df %>%
  rename(
    "Median Home Value" = median_home_value,
    "Republican" = republican,
    "1 year" = pct_1y,
    "2 years" = pct_2y,
    "3 years" = pct_3y,
    "4 years" = pct_4y,
    "5 years" = pct_5y
  )

library(dplyr)
summ_df_num <- summ_df %>%
  select(where(is.numeric))   # keep only numeric columns

stargazer(
  as.data.frame(summ_df_num),
  type = "latex",
  out = "output/tables/summary_stats.tex",
  summary.stat = c("n", "mean", "sd", "min", "p25", "median", "p75", "max"),
  digits = 2,
  header = FALSE,
  float = FALSE
)

# 3) Main regressions (city + year FE)
reg_1y <- lm(pct_1y ~ republican + city + year, data = df)
reg_2y <- lm(pct_2y ~ republican + city + year, data = df)
reg_3y <- lm(pct_3y ~ republican + city + year, data = df)
reg_4y <- lm(pct_4y ~ republican + city + year, data = df)
reg_5y <- lm(pct_5y ~ republican + city + year, data = df)

# 4) Clustered SEs by city (panel-appropriate)
se_cl <- function(model, cluster_vec) {
  sqrt(diag(vcovCL(model, cluster = cluster_vec)))
}

se1 <- se_cl(reg_1y, df$city)
se2 <- se_cl(reg_2y, df$city)
se3 <- se_cl(reg_3y, df$city)
se4 <- se_cl(reg_4y, df$city)
se5 <- se_cl(reg_5y, df$city)

# 5) Regression table -> output/tables/reg_results.tex
# IMPORTANT: export ONLY tabular (no floating table environment).
stargazer(
  reg_1y, reg_2y, reg_3y, reg_4y, reg_5y,
  type = "latex",
  out = "output/tables/reg_results.tex",
  header = FALSE,
  float = FALSE,     # <-- critical: makes it easy to wrap in report.tex
  digits = 3,
  keep = "republican",
  covariate.labels = c("Republican mayor"),
  se = list(se1, se2, se3, se4, se5),
  dep.var.labels = c("1-year", "2-year", "3-year", "4-year", "5-year"),
  omit.stat = c("f", "ser"),
  add.lines = list(
    c("City FE", "Yes", "Yes", "Yes", "Yes", "Yes"),
    c("Year FE", "Yes", "Yes", "Yes", "Yes", "Yes"),
    c("SEs", "Clustered by city", "Clustered by city", "Clustered by city", "Clustered by city", "Clustered by city")
  ),
  notes = "Outcomes are forward-looking percent changes in median home value.
  Standard errors clustered by city.",
  notes.append = FALSE
  )

# 6) Figures -> output/figures/*.pdf (vector)
# 6a) Coefficient plot across horizons (with 95% CI)

coef_df <- tibble(
  horizon = factor(c("1y","2y","3y","4y","5y"), levels = c("1y","2y","3y","4y","5y")),
  beta = c(coef(reg_1y)["republican"],
           coef(reg_2y)["republican"],
           coef(reg_3y)["republican"],
           coef(reg_4y)["republican"],
           coef(reg_5y)["republican"]),
  se = c(se1["republican"], se2["republican"], se3["republican"], se4["republican"], se5["republican"])
) %>%
  mutate(
    lo = beta - 1.96 * se,
    hi = beta + 1.96 * se
  )

p_coef <- ggplot(coef_df, aes(x = horizon, y = beta)) +
  geom_hline(yintercept = 0) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.4, color = "red") +
  labs(
    x = "Horizon",
    y = "Effect (%)",
    title = "Effect of Republican Mayor on Future Home Price Growth",
    subtitle = "City & Year Fixed effects; Clustered by City"
  ) +
  theme_bw()

ggsave(
  filename = "output/figures/coefplot.pdf",
  plot = p_coef,
  # device = cairo_pdf,   # vector pdf (recommended)
  width = 6.5,
  height = 4
)

# states your professor mentioned
states_keep <- c("CA", "NY", "FL")

# subset data
df_state <- df %>%
  filter(abb %in% states_keep)

# helper function: run one regression and return coef + clustered SE
run_state_model <- function(data, outcome_var, horizon_label, state_label) {
  
  # formula with city and year FE
  fmla <- as.formula(paste0(outcome_var, " ~ republican + city + year"))
  
  model <- lm(fmla, data = data)
  
  # clustered SE by city
  vcov_state <- vcovCL(model, cluster = data$city)
  se_state <- sqrt(diag(vcov_state))
  
  tibble(
    state = state_label,
    horizon = horizon_label,
    beta = coef(model)["republican"],
    se = se_state["republican"]
  )
}

# run regressions for each state and each horizon
coef_state_df <- map_dfr(states_keep, function(st) {
  
  d <- df_state %>% filter(abb == st)
  
  bind_rows(
    run_state_model(d, "pct_1y", "1y", st),
    run_state_model(d, "pct_2y", "2y", st),
    run_state_model(d, "pct_3y", "3y", st),
    run_state_model(d, "pct_4y", "4y", st),
    run_state_model(d, "pct_5y", "5y", st)
  )
}) %>%
  mutate(
    horizon = factor(horizon, levels = c("1y", "2y", "3y", "4y", "5y")),
    lo = beta - 1.96 * se,
    hi = beta + 1.96 * se
  )

# plot
p_state_coef <- ggplot(coef_state_df, aes(x = horizon, y = beta)) +
  geom_hline(yintercept = 0, linewidth = 0.8) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.15, color = "red") +
  facet_wrap(~ state, ncol = 2) +
  labs(
    x = "Horizon",
    y = "Effect (%)",
    title = "Effect of Republican Mayor on Future Home Price Growth by State",
    subtitle = "City & Year Fixed Effects; Standard Errors Clustered by City"
  ) +
  theme_bw()

ggsave(
  filename = "output/figures/coefplot_by_state.pdf",
  plot = p_state_coef,
  width = 8,
  height = 6
)

# 6b) Descriptive trend (mean median home value by party over time)
trend_df <- df %>%
  group_by(year, mayor_pid) %>%
  summarise(mean_mhv = mean(median_home_value, na.rm = TRUE), .groups = "drop") %>%
  mutate(year_num = as.numeric(as.character(year)))

p_trend <- ggplot(trend_df, aes(x = year_num, y = mean_mhv, 
                                group = mayor_pid, color = mayor_pid)) +
  geom_line(linewidth = .8) +
  geom_point(size = 1.5) +
  scale_color_manual(values = c("D" = "blue", "R" = "red")) + 
  labs(
    x = "Year",
    y = "Avergae Median Home Value",
    title = "Average Median Home Value Over Time",
    subtitle = "Descriptive"
  ) +
  theme_bw()

ggsave(
  filename = "output/figures/mean_homevalue_by_party.pdf",
  plot = p_trend,
 # device = cairo_pdf,
  width = 6.5,
  height = 4
)
