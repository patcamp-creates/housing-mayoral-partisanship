# Mayoral Partisanship and its Effect on Housing Cost

**Patrick Campbell** - QSS 82 One Quarter Research Project - Dartmouth College

Does the party of a city's mayor predict future housing price growth? I estimate panel regressions with city
and year fixed effects (SEs clustered by city) on a city-year panel of U.S. cities, 2005-2019, using 1- to
5-year forward percent changes in median home value as outcomes.

**Finding:** No strong or consistent relationship between Republican mayors and future housing price growth at
any horizon. Results are descriptive associations, not causal estimates.

## Repository structure
```
code/          R scripts, run in numbered order
data/          data documentation (raw data not included)
report/        final paper and poster (PDF)
literature/    literature review notes and source papers
```

## How to reproduce
1. Open `housing-mayoral-partisanship.Rproj` in RStudio so paths resolve from the project root.
2. Install packages: `tidyverse`, `tidycensus`, `stargazer`, `sandwich`, `lmtest`, `scales`.
3. Set up data per [`data/README.md`](data/README.md).
4. Run the scripts in order:

| Script | What it does |
|---|---|
| `01_QSS_Housing_Data.R` | Pulls ACS median home values by state and year via `tidycensus` |
| `02_Merge_Data.R` | Stacks state files and merges with mayoral election data |
| `03_Linear_Regression.R` | Fixed-effects regressions, 1-5 year horizons |
| `04_Visualizations.R` | Descriptive summaries and plots |
| `05_Overleaf.R` | Exports summary table, regression table, and figures for the LaTeX report |

## Report
- [`report/Final_Report.pdf`](report/Final_Report.pdf)
- [`report/Final_Poster.pdf`](report/Final_Poster.pdf)

## Literature
See [`literature/README.md`](literature/README.md).
