# Data

Raw data files are **not** stored in this repo. To reproduce the analysis:

| Dataset | Source | Used in |
|---|---|---|
| Median home value, city-level, 2005-2019 | U.S. Census Bureau American Community Survey 1-year estimates (table B25077_001), pulled with the `tidycensus` R package. Requires a free [Census API key](https://api.census.gov/data/key_signup.html). | `code/01_QSS_Housing_Data.R` |
| Mayoral party affiliation by city-year | Mayoral election data assembled by de Benedictis-Kessner & Warshaw (see `literature/`). Replication materials: https://doi.org/10.7910/DVN/TEPRY2 | `code/02_Merge_Data.R` |

## Setup
1. Get a Census API key and run `census_api_key("YOUR_KEY", install = TRUE)` once. This stores it in your
   `~/.Renviron`, **not** in this repo.
2. Place the election data where `02_Merge_Data.R` expects it.
3. After merging, the analysis scripts read `data/data.csv`.

## Final analysis dataset (`data/data.csv`)
City-year panel (N = 1,178), restricted to cities with at least one mayoral party change between 2005 and 2019.
