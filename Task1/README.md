# Assignment 1: Dataset Exploration & Problem Framing

## Dataset Overview

**Dataset:** [World Happiness Report](https://www.kaggle.com/datasets/unsdsn/world-happiness) (2015-2019)

The World Happiness Report ranks countries by self-reported well-being (a "Happiness Score" from
0-10, based on Gallup World Poll surveys) and explains variation in that score using six factors:
GDP per capita, social support, healthy life expectancy, freedom to make life choices, generosity,
and perceptions of corruption. This analysis combines all five years (2015-2019) into a single
782-row dataset covering 170 countries.

Each year's raw file uses slightly different column names (e.g., `Family` in 2015-2016 vs.
`Social support` in 2018-2019), so the notebook standardizes all five files onto a common schema
before combining them: `Country`, `Year`, `Happiness Rank`, `Happiness Score`, `GDP per Capita`,
`Social Support`, `Health`, `Freedom`, `Trust`, `Generosity`.

## Business Problem(s)

1. **Drivers of happiness** — which factors most strongly explain a country's happiness score?
2. **Happiness score prediction** — predict a country's happiness score from its socioeconomic
   indicators. *(primary focus of this analysis)*
3. **Country clustering / peer grouping** — group countries by well-being profile, beyond simple
   geographic region.
4. **Trend analysis** — identify which countries or regions are improving or declining over time.

## ML Problem Framing

**Chosen approach: Regression (supervised learning)**

`Happiness Score` is a continuous numeric value (not a category), and each country-year already
has a known outcome to learn from — the two conditions that define a supervised regression problem,
as opposed to classification (categorical target) or clustering (no known target at all).

| Business Problem | ML Problem Type |
|---|---|
| Drivers of happiness | Regression (+ feature importance) |
| Happiness score prediction | Regression |
| Country clustering | Clustering |
| Trend analysis | Time-series / descriptive analysis |

## Target Variable & Key Features

**Target:** `Happiness Score` (continuous, 0-10)

**Features:** `GDP per Capita`, `Social Support`, `Health` (life expectancy), `Freedom`, `Trust`
(perceptions of corruption), `Generosity`. `Happiness Rank` is excluded as a feature since it's
derived directly from the target and would leak the answer.

## Three Key Observations

1. **GDP per capita and health are the strongest single correlates of happiness; generosity is by
   far the weakest.** Correlation with `Happiness Score` across all five years: GDP per Capita
   (0.79), Health (0.74), Social Support (0.65), Freedom (0.55), Trust (0.40), Generosity (0.14).
2. **The `Trust` column has exactly one missing value** — the United Arab Emirates in the 2018 file
   — out of 782 total rows. A tiny gap, but a model pipeline still needs explicit handling for it.
3. **The same small group of countries dominates the top and bottom of the ranking across all five
   years.** Denmark, Norway, Finland, Switzerland, and Iceland are the five highest-averaging
   countries (2015-2019); Burundi, the Central African Republic, Syria, South Sudan, and Rwanda are
   the five lowest — suggesting happiness is driven more by stable, structural conditions than
   short-term shocks over this window.

## Repository Contents

- `analysis.ipynb` — full dataset exploration and problem framing using Pandas
- `README.md` — this file
- `2015.csv`, `2016.csv`, `2017.csv`, `2018.csv`, `2019.csv` — the raw source data
