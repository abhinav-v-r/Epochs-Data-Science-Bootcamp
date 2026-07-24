# Used Car Price Prediction — EDA, Data Cleaning & Feature Engineering

**Epochs '26 — Assignment 3** · `#evn-ds-epochs26-day03`

## 📂 Dataset Overview

- **Source:** [Used Car Price Prediction Dataset](https://www.kaggle.com/datasets/taeefnajib/used-car-price-prediction-dataset) (Kaggle)
- **Size:** 4,009 rows × 12 raw columns
- **Target variable:** `price` (listing price, USD)
- **Columns:** `brand`, `model`, `model_year`, `milage`, `fuel_type`, `engine`, `transmission`, `ext_col` (exterior color), `int_col` (interior color), `accident`, `clean_title`, `price`
- **Feature types:**
  - Numerical (native): `model_year`
  - Numerical stored as text (needed cleaning): `milage` (e.g. `"51,000 mi."`), `price` (e.g. `"$10,300"`)
  - Categorical / free text: `brand`, `model`, `fuel_type`, `engine`, `transmission`, `ext_col`, `int_col`, `accident`, `clean_title`

## 🔎 Data Quality Issues Identified

| Issue | Detail |
|---|---|
| Numeric columns stored as strings | `milage` and `price` contained unit suffixes and formatting characters (`" mi."`, `"$"`, `","`) preventing numeric operations |
| Missing values | `fuel_type` (170), `accident` (113), `clean_title` (596) |
| Uninformative placeholder values | `fuel_type` contained `"–"` and `"not supported"` entries that carry no real information |
| Skewed / inconsistent `clean_title` | Column only ever takes the value `"Yes"` — missing values are very likely cars *without* a clean title, not a random unknown |
| Highly fragmented categories | `transmission` has 62 distinct string values that really describe only a handful of underlying transmission types (automatic vs. manual, with speed-count variants) |
| Outliers in `price` | A small number of exotic/luxury vehicles (Bugatti, Lamborghini, Rolls-Royce, Porsche Carrera GT) priced from ~$490K–$2.95M sit far above the rest of the market |
| No exact duplicate rows | Verified via `df.duplicated()` — 0 fully duplicated records found |

## 🛠 Cleaning Techniques Applied

1. **Type correction:** Stripped `" mi."`/`","` from `milage` and `"$"`/`","` from `price`, converting both to `float`.
2. **Missing value handling:**
   - `clean_title`: missing → explicit `"No"` (since the column is otherwise always `"Yes"`).
   - `accident`: missing → explicit `"Unknown"` category (can't assume "no accident" without evidence).
   - `fuel_type`: rows missing `fuel_type` but with an `"Electric Motor"` engine description → recoded to `"Electric"`; remaining placeholder values (`"–"`, `"not supported"`) and any leftover missing values → `"Unknown"`.
3. **Duplicate removal:** Ran `drop_duplicates()` as a formal safeguard (no rows were removed, since the raw data had none).
4. **Outlier handling:** Computed IQR bounds on `price` and created a new `price_capped` column that winsorizes (caps) the 244 high-side outliers at the upper IQR bound, while preserving the original `price` column so no information is destroyed.

## 🧪 Feature Engineering Performed

| New Feature | Description |
|---|---|
| `car_age` | `2026 - model_year` — how old the car is; generally more directly predictive than model year alone |
| `milage_per_year` | `milage / car_age` — average annual mileage, a proxy for usage intensity |
| `horsepower` | Numeric HP value extracted via regex from the free-text `engine` description |
| `engine_liters` | Numeric engine displacement (in liters) extracted via regex from `engine` |
| `is_automatic` | Binary flag collapsing the 62 raw `transmission` strings into automatic (1) vs. manual (0) |
| `had_accident` | Binary flag derived from `accident` (1 = at least one reported accident/damage) |

`horsepower` and `engine_liters` had residual gaps where the engine string didn't state that value; these were imputed using each brand's median (falling back to the dataset-wide median where a brand had no values at all), leaving **zero missing values** in the final cleaned dataset.

## 📊 Five Key Insights

1. **Brand concentration:** The top 5 brands (Ford, BMW, Mercedes-Benz, Chevrolet, Porsche) account for a large share of all listings — the market in this dataset is dominated by a handful of makes.
2. **`clean_title` missingness is informative, not random:** the field only ever contains `"Yes"`, so its ~15% missing rate almost certainly encodes "title not clean" rather than an unknown value.
3. **Price is heavily right-skewed by exotic cars:** the mean list price is pulled well above the median by a small number of supercars in the $490K–$2.95M range, meaning models should consider capping or a log-transform of price.
4. **Transmission labeling is extremely fragmented:** 62 distinct raw strings (`"A/T"`, `"8-Speed A/T"`, `"Automatic"`, `"8-Speed Automatic"`, etc.) really describe only two functional transmission types, which is why the `is_automatic` feature is useful for modeling.
5. **Missing `fuel_type` often means "Electric," not "unknown":** cross-referencing the free-text `engine` field showed a meaningful share of missing `fuel_type` rows were fully electric vehicles (`"...HP Electric Motor Electric Fuel System"`), letting us recover real information rather than discard it.

## 📁 Repository Contents

- `task-3.ipynb` — full EDA, data cleaning, and feature engineering workflow (executed, with outputs and charts)
- `cleaned_used_cars.csv` — final cleaned dataset (4,009 rows × 19 columns, zero missing values)
- `README.md` — this file
- 
