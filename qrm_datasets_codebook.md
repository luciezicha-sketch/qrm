# QRM practice datasets — codebook

Quantitative Research Methods · Leiden University College

These four files are used in the practice exercises at the start of the course.
They are **simulated data**, built to teach specific problems. Nothing in them
describes real people or real countries beyond the country names.

Read this codebook before you open any of them. That is the habit the whole
course is trying to build: the file does not tell you what `999999` means, and
neither does R.

---

## 1. `qrm_students_clean.csv`

A tidy, well-behaved file. Import it with `read.csv()` and nothing else. Use it
for descriptives, plots, group comparisons and a first regression, while there
is nothing wrong with the data to distract you.

**80 rows, one per student. Comma separated, full stop as decimal mark, no missing values.**

| Variable | Type | Values | Meaning |
|---|---|---|---|
| `student_id` | numeric | 1001–1080 | Unique identifier |
| `age` | numeric | 18–23 | Age in years |
| `gender` | character | `f`, `m`, `nb` | Self-described gender |
| `year` | numeric | 1–3 | Year of study |
| `hours_study` | numeric | 0.5–20 | Self-reported study hours per week |
| `exam_score` | numeric | 0–100 | Final exam mark |
| `satisfaction` | numeric | 1–7 | Course satisfaction, 1 = very low, 7 = very high |

There is a real relationship built into this file between `hours_study` and
`exam_score`. You should be able to find it.

Note that `year` and `satisfaction` are **ordinal**, stored as numbers. Whether
it is defensible to average them is a measurement question, not an R question.

---

## 2. `qrm_survey_messy.csv`

The same shape of data as a real downloaded survey file, with the problems real
files have. `read.csv()` with default settings will import this **wrongly and
without any error**. Work out why before you go further.

**92 rows. Semicolon separated. Comma as the decimal mark.**

| Variable | Type | Values | Meaning |
|---|---|---|---|
| `respondent_id` | numeric | 2001–2090 | Identifier — but see the warning below |
| `country` | character | 12 countries | Country of residence |
| `age` | numeric | 18–70 | Age in years. `-99` = declined to answer |
| `income_monthly` | numeric | approx. 600–5500 | Net monthly income in euro. `999999` = missing. Blank = not asked |
| `party` | numeric | 1, 2, 3, 9 | 1 = left, 2 = centre, 3 = right, **9 = refused** |
| `turnout` | numeric | 0, 1 | 0 = did not vote, 1 = voted |
| `education` | numeric | 1–4 | 1 = secondary, 2 = vocational, 3 = bachelor, 4 = master or above |

**Known problems in this file.** All of them are deliberate.

1. The columns are separated by semicolons, not commas.
2. The decimal mark is a comma, so `2405,78` means 2405.78. Deleting that comma
   rather than replacing it makes every income a hundred times too large.
3. `income_monthly` uses `999999` as a missing-value code. It is not a salary.
4. `age` uses `-99` as a missing-value code, and one respondent has an age of
   `240`, which is a typing slip for 24.
5. `party` uses `9` for refused. Averaging this variable is meaningless anyway.
6. `country` is written inconsistently: `netherlands`, `Netherlands`,
   `NETHERLANDS` and `netherlands ` with a trailing space all appear. There are
   12 countries but 36 distinct spellings.
7. Two rows are exact duplicates of earlier rows. `respondent_id` is therefore
   **not unique**, and you have to decide whether that is a data-collection
   problem or a file-handling one.
8. A few income cells are empty.

If your cleaned file has 12 countries, no value above about 6000 in income, and
90 unique ids, you have found all of them.

---

## 3. `qrm_gdp_wide.csv`

A small country-by-year panel in **wide** format: one row per country, one
column per year. Use it to practise reshaping.

**12 rows, 6 columns. Comma separated.**

| Variable | Type | Meaning |
|---|---|---|
| `country` | character | Country name, capitalised |
| `gdp_2000` … `gdp_2020` | numeric | GDP per capita in euro, at five-year intervals |

Reshaped to long it should give **60 rows** — 12 countries × 5 years. If you get
a different number, something did not stack.

Two things to check afterwards: that `year` came back as a *number* and not as
text, and that the row count multiplied as expected.

---

## 4. `qrm_country_indicators.csv`

Country-level information, to be merged onto the survey file.

**10 rows, 4 columns. Comma separated.**

| Variable | Type | Meaning |
|---|---|---|
| `country` | character | Country name, **capitalised** |
| `region` | character | Western, Southern, Eastern, Northern Europe |
| `eu_member` | logical | TRUE for every country in this file |
| `pop_millions` | numeric | Population in millions |

**Two deliberate traps.**

First, the country names here are capitalised, while the survey file has them in
mixed case with stray spaces. Merge the two files without cleaning the key and
you will match **zero rows** — with no error message.

Second, this file has 10 countries and the survey has 12. **Norway and Turkey
are missing here.** A default `merge()` will silently delete every respondent
from those two countries, which changes your sample without telling you. Use
`all.x = TRUE` and then count how many failed to match.

---

## Suggested order of work

1. `qrm_students_clean.csv` — descriptives, plots, t-test, simple regression.
2. `qrm_survey_messy.csv` — import it correctly, then clean it. This is the long one.
3. `qrm_gdp_wide.csv` — reshape to long and back.
4. Merge the cleaned survey onto `qrm_country_indicators.csv`, and check the join.

Sections 7 to 10 of the *Getting started with R* script cover exactly these four
steps, in this order.

---

*Simulated data. Any resemblance to real survey results is coincidental and, given
how these files were built, would be quite surprising.*
