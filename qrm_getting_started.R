###############################################################################
#
#  QUANTITATIVE RESEARCH METHODS
#  Getting started with R — reference script
#
#  Leiden University College  ·  Dr. Lucie Zicha
#
#  ---------------------------------------------------------------------------
#  Nothing here is graded or submitted. 
#
#  HOW TO USE IT
#  Put your cursor on a line and press Ctrl+Enter (Windows) or Cmd+Enter (Mac).
#  The line runs in the console. Go top to bottom, and read what comes back
#  before moving on — that feedback is the point of the exercise.
#
#  Lines starting with # are comments. R ignores them; they are for you.
#
#  CONTENTS
#    1.  Best practice: how to write code you can trust
#    2.  RStudio, projects, and file paths
#    3.  Objects, vectors, and types
#    4.  Missing values
#    5.  Functions, help, and packages
#    6.  Data frames
#    7.  Importing data
#    8.  Cleaning data
#    9.  Wide and long format
#    10. Searching, sorting, and merging
#    11. Descriptives and first plots
#    12. Reading error messages
#    13. Where to go next
#
###############################################################################



###############################################################################
###############################################################################
#  1.  BEST PRACTICE: HOW TO WRITE CODE 
###############################################################################
###############################################################################

# Read this section properly. 

# --- 1.1  The script is the analysis -----------------------------------------
#
# The console is a scratchpad. It forgets anything you type in ocne you close Rstudio. 
# The script is the record of what you
# did, and it is the only thing that makes your result checkable, either by your
# supervisor, by a journal referee, or by you in three weeks when you cannot
# remember whether you dropped those seventeen cases before or after recoding.
#
# Concretely: never fix a data problem by clicking, by editing the spreadsheet,
# or by typing a one-off command into the console. Fix it with a line in the
# script. If it is not in the script, it did not happen. 
# In your submitted work, if the results cannot be replicable from your Rscript, 
# they will not be graded.
#


# --- 1.2  The reproducibility test -------------------------------------------
#
# Every R session, do this:
#
#   Session > Restart R   (Ctrl+Shift+F10 / Cmd+Shift+F10)
#   then run your whole script from line 1
#
# If it runs clean, your analysis is reproducible. If it breaks, you were
# depending on something that existed only in your Environment — an object you
# created in the console and forgot, or a package you loaded by hand, a variable
# you renamed halfway through. 
#
# Turn off workspace saving so this test is honest:
#   Tools > Global Options > General
#     - untick "Restore .RData into workspace at startup"
#     - set "Save workspace to .RData on exit" to Never
#
# Some people put rm(list = ls()) at the top of a script to clear everything.
# It is a weaker version of the same idea: it clears objects but not loaded
# packages or changed options. Restarting R is the real test.


# --- 1.3  Structure every script the same way --------------------------------
#
# A predictable shape means you can find anything in anyone's script in ten
# seconds. Use this order:
#
#   1. HEADER      what this script does, who wrote it, when, what it needs
#   2. SETUP       library() calls, options
#   3. IMPORT      read the raw data in, change nothing
#   4. CLEAN       fix variable types, recode, handle missing values, filter
#   5. EXPLORE     descriptives and plots
#   6. ANALYSE     the models
#   7. OUTPUT      tables, figures, saved objects
#
# Keep those steps separate and in that order. The most common source of a
# result nobody can reproduce is analysis code tangled up with cleaning code, so
# that nobody — including the author — can say what the sample actually was.


# --- 1.4  Section headers and the outline pane -------------------------------
#
# Any comment line ending in four or more dashes, equals signs or hashes becomes
# a foldable section in RStudio. Press Ctrl+Shift+O / Cmd+Shift+O to open the
# document outline and jump around a long script instantly.

# Example section header ------------------------------------------------------


# --- 1.5  Naming things ------------------------------------------------------
#
# Objects:
#   - lower case, words joined by underscores: gdp_per_capita, model_1
#   - name what it IS, not what type it is: turnout, not turnout_vector
#   - be consistent within a project; do not mix styles
#   - never reuse a function name: do not create objects called mean, data,
#     sum, df, c, t or T
#
# Files:
#   - no spaces, no accents, no slashes
#   - number them if order matters: 01_import.R, 02_clean.R, 03_analysis.R
#   - if you version by hand, use dates: analysis_2026-03-14.R
#     never final.R, final2.R, final_REALLY_final.R
#
 
# R is case-sensitive. Turnout, turnout and TURNOUT are three different objects.


# --- 1.6  Comment the why, not the what --------------------------------------
#
# Bad:
#   x <- x[x$age > 17, ]     # keep rows where age is over 17
#
# Good:
#   x <- x[x$age > 17, ]     # drop minors: consent was not collected for them
#
# The code already says what it does. What it cannot say is why you made that
# decision, and the why is what a reader — or a marker — needs.
#
# Write the comment as you write the line. Comments added afterwards are either
# never added or quietly wrong.


# --- 1.7  Formatting that makes problems visible ---------------------------------
#
# These are conventions, not rules R enforces, but they are near-universal:
#
#   - spaces around operators:      x <- y + 1        not   x<-y+1
#   - space after every comma:      mean(x, na.rm = TRUE)
#   - keep lines under ~80 characters; break long function calls across lines
#   - one operation per line: do not chain six things onto one line to be clever
#   - indent inside braces and function calls
#
# RStudio will do most of it for you: select code and press Ctrl+I / Cmd+I to
# reindent, or Ctrl+Shift+A / Cmd+Shift+A to reformat a selection.


# --- 1.8  Protect the raw data -----------------------------------------------
#
# The raw data file is read-only. Forever. You never edit it, never re-save it
# from Excel, never "just fix that one cell".
#
# Recommended folder layout inside your project:
#
#   QRM/
#     QRM.Rproj
#     data-raw/     downloaded files, untouched
#     data-clean/   what your cleaning script produces
#     scripts/      01_import.R, 02_clean.R, 03_analysis.R
#     output/       figures and tables
#
# Every change is stored in a script, so every change is visible, reversible and
# explainable.


# --- 1.9  Asking for help well -----------------------------------------------
#
# When you are stuck, send three things: the exact error message copied in full,
# the smallest piece of code that reproduces it, and the output of sessionInfo().
# That answers most of the follow-up questions before they are asked.
#
# Before asking, spend ten minutes: read the error, check the spelling, check
# getwd(), restart R and re-run from the top. After twenty minutes stuck, ask.
# Two hours stuck is not perseverance, it is wasted time.



###############################################################################
###############################################################################
#  2.  RSTUDIO, PROJECTS, AND FILE PATHS
###############################################################################
###############################################################################

# R is the language. RStudio is the program you write it in. You open RStudio.
#
# Four panes:
#   Source (top left)        this script. Your actual work.
#   Console (bottom left)    where code runs and results appear.
#   Environment (top right)  every object currently in memory.
#   Files/Plots (bottom right) your folder, your graphs, and the help viewer.


# --- 2.1  Make a project -----------------------------------------------------
#
# Do this once, now:
#   File > New Project > New Directory > New Project
#   Name it QRM and save it somewhere you will find again.
#
# From then on, open the project (not the file) and R starts in that folder
# automatically.

getwd()   # which folder is R looking at right now?
list.files()   # what can it see there?


# --- 2.2  Careful with setwd() --------------------------------------------------
#
# When you use:
#
#   setwd("C:/Users/lucie/Desktop/stats stuff/final2/")
#
# That path exists on exactly one computer. The script then does not work for everyone else,
# including you after you change your file organization. When working with others, it's easier to just write the
# path relative to the project folder:
#
#   read.csv("data-raw/survey.csv")
#
# Use forward slashes even on Windows. Backslashes are escape characters in R
# and "C:\data" will not work.



###############################################################################
###############################################################################
#  3.  OBJECTS, VECTORS, AND TYPES
###############################################################################
###############################################################################

# --- 3.1  R as a calculator, and the assignment arrow ------------------------

2 + 2
10 / 4
3 ^ 2
sqrt(81)

# Results printed to the console vanish. To keep one, name it with  <-
# (shortcut: Alt+- on Windows, Option+- on Mac).

n_students <- 42
n_students


# --- 3.2  Vectors ------------------------------------------------------------
#
# A vector is a sequence of values of the same type. c() combines them.

age    <- c(19, 21, 20, 22, 19, NA)
gender <- c("f", "m", "f", "nb", "m", "f")
passed <- c(TRUE, TRUE, FALSE, TRUE, TRUE, FALSE)

length(age)
class(age)
class(gender)
class(passed)

# Operations apply to the whole vector at once. No loop needed.
age * 12          # age in months
age > 20          # a logical vector: one TRUE/FALSE per element

# Useful shorthands:
1:10
seq(0, 100, by = 25)
rep("a", times = 3)


# --- 3.3  Three types of Data in R --------------------------------------------------
#
# Almost every variable in this course is stored in one of three ways. They can
# look identical when printed, but R treats them completely differently. 
#
#   NUMERIC    quantities. Arithmetic is meaningful: you can add them, average
#              them, put them in a regression. Age, income, GDP, a test score.
#
#   CHARACTER  text. R stores the characters and nothing else. It will not do
#              arithmetic on them, and it has no idea that "10" is bigger than
#              "9" — it sorts alphabetically, so "10" comes first.
#
#   FACTOR     a category from a fixed set. Underneath, R stores small integers
#              plus a lookup table of labels, called the LEVELS. This is how you
#              tell R that a variable is nominal: party, country, treatment
#              group, education level.
#
# The same three values, stored three ways:

scores_num <- c(10, 20, 30)                   # numeric: quantities
scores_chr <- c("10", "20", "30")             # character: text that looks numeric
scores_fct <- factor(c("10", "20", "30"))     # factor: category labels

class(scores_num)     # "numeric"
class(scores_chr)     # "character"
class(scores_fct)     # "factor"


# Any vector holds ONE type. If you mix types on purpose or by accident, R  converts everything to the
# most flexible one, which is usually character. This may cause issues.

mixed <- c(1, 2, "three")
class(mixed)      # "character" — the numbers are now text

# mean(mixed)     # Error: argument is not numeric or logical

as.numeric(c("1", "2", "three"))   # note the NA and the warning

# When a numeric column imports as character, do not just wrap it in
# as.numeric(). Find out what non-numeric value is in there — it is usually a
# missing-value code, a thousands separator, or a stray footnote marker.


###############################################################################
###############################################################################
#  4.  MISSING VALUES
###############################################################################
###############################################################################

# NA means "we do not know". It is not zero and not an empty string. Real
# survey data is full of it.

mean(age)                 # NA — one unknown makes the whole mean unknown
mean(age, na.rm = TRUE)   # drop missing values first

is.na(age)                # which entries are missing?
sum(is.na(age))           # how many?
mean(is.na(age))          # what proportion?

# Never write NA in quotes. "NA" is the two-letter word, not a missing value:
c(1, 2, "NA")
c(1, 2, NA)


###############################################################################
###############################################################################
#  5.  FUNCTIONS, HELP, AND PACKAGES
###############################################################################
###############################################################################

# A function takes arguments and returns something.
round(3.14159, digits = 2)

# Every function has a help page. The Arguments and Examples sections are the
# useful parts.
?round
?mean
??"standard deviation"     # search when you cannot remember the name

# Packages:
#   install.packages("name")   ONCE per computer. Downloads it.
#   library(name)              EVERY session. Loads it.
#
# Installing a package is buying the book; library() is taking it off the shelf to use.
#
# Leave install.packages() commented out in scripts you share, so it does not
# reinstall on someone else's machine every time they run your code.

# install.packages(c("readxl", "haven", "tidyr"))

# Everything in sections 1 to 6 is base R, so there is nothing to install today.
# Sections 7 and 9 mention a few packages where they genuinely help.



###############################################################################
###############################################################################
#  6.  DATA FRAMES
###############################################################################
###############################################################################

# A data frame is a table: rows are cases, columns are variables. 

survey <- data.frame(
  id     = 1:6,
  age    = age,
  gender = gender,
  passed = passed
)

survey

# LOOK AT IT BEFORE YOU ANALYSE IT. Always. Every time.
str(survey)        # structure: names, types, first values. The most useful one.
head(survey)       # first six rows
tail(survey)       # last six — often where the junk rows hide
dim(survey)        # rows, columns
nrow(survey); ncol(survey)
names(survey)      # column names
summary(survey)    # quick descriptives per column
# View(survey)     # spreadsheet-style viewer (capital V)


# --- 6.1  Getting at parts of it ---------------------------------------------

survey$age                  # one column, by name
survey[1, ]                 # first row, all columns
survey[, "age"]             # all rows, one column
survey[3, 2]                # row 3, column 2

# Filtering with a logical condition — the workhorse of data analysis.
survey[survey$age > 20, ]                  # note the comma before ]
survey[survey$gender == "f", ]             # == tests, = assigns
survey[!is.na(survey$age), ]               # ! means "not"
survey[survey$age > 19 & survey$passed, ]  # & is and, | is or

# Making a new variable is just assigning into a new column:
survey$age_group <- ifelse(survey$age < 21, "younger", "older")
survey



###############################################################################
###############################################################################
#  7.  IMPORTING DATA
###############################################################################
###############################################################################

# Getting data in correctly is half of applied quantitative work. An import
# mistake does not usually announce itself — it produces a data frame that looks
# fine and is wrong.


# --- 7.1  Before you import --------------------------------------------------
#
# Open the file in a plain text editor (Notepad, TextEdit, or RStudio's own
# editor) and look at the first few lines. You are checking:
#
#   - what separates the columns: comma, semicolon, tab?
#   - is the decimal point a . or a , ?
#   - is there a header row of variable names?
#   - are there junk rows above the header — a title, a note, a blank line?
#   - how is missing data written: blank, NA, ., 999, -99, "N/A"?
#   - are text values wrapped in quotes?
#
# DO NOT open a .csv in Excel first. Excel silently converts things that look
# like dates, drops leading zeros from ID codes and postcodes, and may rewrite
# the decimal separator when it saves. This is a genuine and common source of
# corrupted data in published research.


# --- 7.2  CSV files ----------------------------------------------------------

# The straightforward case:
# survey <- read.csv("data-raw/survey.csv")

# The arguments you will actually need:
# survey <- read.csv(
#   file             = "data-raw/survey.csv",
#   header           = TRUE,                       # first row is variable names
#   sep              = ",",                        # column separator
#   dec              = ".",                        # decimal mark
#   na.strings       = c("", "NA", "N/A", "999", "-99"),   # missing codes
#   stringsAsFactors = FALSE,                      # keep text as text
#   skip             = 0,                          # junk rows above the header
#   encoding         = "UTF-8"                     # for accented characters
# )

# European CSVs are often semicolon-separated with a comma decimal mark:
# survey <- read.csv2("data-raw/survey_nl.csv")     # shorthand for sep=";" dec=","

# Tab-separated:
# survey <- read.delim("data-raw/survey.tsv")

# na.strings is the argument students forget, and it matters most. If the
# codebook says missing income is recorded as 999999, put it in na.strings. If
# you do not, R reads it as a real salary and your mean is nonsense — with no
# error message at all.


# --- 7.3  Excel, Stata, SPSS -------------------------------------------------
#
# Replication packages very often ship .dta (Stata) or .sav (SPSS) files, so you
# will need these.

# library(readxl)
# survey <- read_excel("data-raw/survey.xlsx", sheet = 1)

# library(haven)
# survey <- read_dta("data-raw/replication.dta")    # Stata
# survey <- read_sav("data-raw/wvs.sav")            # SPSS
#
# haven keeps the variable labels and the value labels from Stata and SPSS,
# which is a large part of the codebook. Look at them:
# attributes(survey$party)$labels


# --- 7.4  R's own formats ----------------------------------------------------
#
# For saving a cleaned dataset between scripts, use RDS. It preserves types,
# factor levels and everything else exactly.

# saveRDS(survey, "data-clean/survey_clean.rds")
# survey <- readRDS("data-clean/survey_clean.rds")


# --- 7.5  Check every import -------------------------------------------------
#
# Run these four lines after every single import, without exception:
#
#   dim(survey)       do the row and column counts match the codebook?
#   str(survey)       is every variable the type it should be?
#   summary(survey)   any impossible minimum or maximum? any surprise NAs?
#   head(survey); tail(survey)   is the first row data, or a stray header?
#
# The classic silent failures:
#   - one column, not many          -> wrong sep
#   - every column is character     -> wrong dec, or a missing code like "."
#   - variable names are V1, V2     -> header = FALSE, or junk rows above
#   - names are X1st.wave etc.      -> R made illegal names legal; rename them
#   - a max of 999                  -> missing code not declared in na.strings
#   - one extra empty last column   -> trailing separator on each row



###############################################################################
###############################################################################
#  8.  CLEANING DATA
###############################################################################
###############################################################################

# Cleaning is where most of the hours go and where most of the mistakes happen.
# Do all of it in the script, in one place, before any analysis.
#
# Build a small messy dataset to practise on:

raw <- data.frame(
  id       = c(1, 2, 3, 4, 5, 5, 7),
  Country  = c("Netherlands", "netherlands ", "Belgium", "BELGIUM", "France", "France", "Germany"),
  income   = c("2100", "2400", "999999", "3100", "2750", "2750", ""),
  party    = c(1, 2, 3, 2, 1, 1, 9),
  age      = c(19, 21, 20, 220, 22, 22, 24),
  stringsAsFactors = FALSE
)
str(raw)


# --- 8.1  Look before you work with it ----------------------------------------------

summary(raw)
table(raw$Country, useNA = "ifany")   # useNA shows missings, which table() hides
table(raw$party, useNA = "ifany")


# --- 8.2  Rename columns to something you can type ---------------------------

names(raw)
names(raw)[names(raw) == "Country"] <- "country"   # rename one
# names(raw) <- c("id","country","income","party","age")   # rename all, by position
names(raw)

# Renaming all columns by position is fast and dangerous: if the column order
# ever changes, you relabel your data wrongly and nothing errors. Prefer
# renaming by name.


# --- 8.3  Whitespace and inconsistent capitalisation -------------------------
#
# "netherlands " and "Netherlands" are two different values to R, so they will
# appear as two separate categories in every table you make.

raw$country <- trimws(raw$country)            # strip leading/trailing spaces
raw$country <- tolower(raw$country)           # force to lower case
table(raw$country)                            # now four countries, not six


# --- 8.4  Missing-value codes ------------------------------------------------
#
# Best fixed at import with na.strings. If you missed it, fix it explicitly:

raw$income[raw$income == ""] <- NA
raw$income <- as.numeric(raw$income)
raw$income[raw$income == 999999] <- NA        # the codebook's missing code
summary(raw$income)

# Same for the party variable, where 9 means "refused":
raw$party[raw$party == 9] <- NA


# --- 8.5  Fixing types -------------------------------------------------------

class(raw$income)

# THE FACTOR TRAP. Converting a factor straight to numeric gives you the
# internal level codes, not the values. This is one of the nastiest silent bugs
# in R because it produces plausible-looking small integers.

f <- factor(c("10", "20", "30"))
as.numeric(f)                       # 1 2 3   <- WRONG
as.numeric(as.character(f))         # 10 20 30 <- correct

# Dates need an explicit format, or R guesses and guesses wrong:
as.Date("14/03/2026", format = "%d/%m/%Y")


# --- 8.6  Impossible values --------------------------------------------------
#
# summary() is your outlier detector. An age of 220 is a typo for 22, not a
# supercentenarian.

summary(raw$age)
raw$age[raw$age > 120] <- NA

# Decide and document: do you correct it, drop it, or set it missing? Whichever
# you choose, say so in a comment. This is exactly the kind of undocumented
# decision that makes a paper fail replication.


# --- 8.7  Duplicates ---------------------------------------------------------

duplicated(raw)             # which rows are exact repeats of an earlier row?
sum(duplicated(raw))
anyDuplicated(raw$id)       # are the ID values unique? (0 means yes)

raw[duplicated(raw$id) | duplicated(raw$id, fromLast = TRUE), ]  # see both copies

clean <- raw[!duplicated(raw), ]
nrow(raw); nrow(clean)

# Before deleting: work out WHY there are duplicates. A genuinely repeated
# respondent is a data collection problem. A row that is duplicated because a
# merge went wrong is a code problem, and deleting it hides the bug.


# --- 8.8  Recoding into categories -------------------------------------------

# Named categories from numeric codes:
clean$party <- factor(clean$party,
                      levels = c(1, 2, 3),
                      labels = c("left", "centre", "right"))
table(clean$party, useNA = "ifany")

# Binning a continuous variable:
clean$age_band <- cut(clean$age,
                      breaks = c(17, 20, 25, Inf),
                      labels = c("18-20", "21-25", "26+"))
table(clean$age_band, useNA = "ifany")

# Two-way recode:
clean$high_income <- ifelse(clean$income > 2500, 1, 0)

# Watch what ifelse() does with NA: it returns NA, which is usually right, but
# means high_income now has missings you need to account for.
table(clean$high_income, useNA = "ifany")


# --- 8.9  Factors and reference categories -----------------------------------
#
# The FIRST level of a factor is the reference category in a regression. R sorts
# levels alphabetically by default, which is almost never the category you want
# to compare everything against. Set it deliberately — this is the whole subject
# of the week 5 dummy variable reading.

levels(clean$party)
clean$party <- relevel(clean$party, ref = "centre")
levels(clean$party)


# --- 8.10  A cleaning checklist ----------------------------------------------
#
#   [ ] row and column counts match the codebook
#   [ ] every variable has the right class
#   [ ] all missing-value codes converted to NA
#   [ ] no impossible values in any summary()
#   [ ] no unintended duplicate IDs
#   [ ] category labels consistent (case, spacing, spelling)
#   [ ] factor reference categories set deliberately
#   [ ] how many cases were dropped, and why, written in a comment
#   [ ] cleaned data saved to data-clean/, raw file untouched



###############################################################################
###############################################################################
#  9.  WIDE AND LONG FORMAT
###############################################################################
###############################################################################

# --- 9.1  What the two shapes are --------------------------------------------
#
# WIDE: one row per unit, one column per time point or item.
#
#   country      gdp_2000  gdp_2010  gdp_2020
#   Netherlands     100       120       140
#   Belgium          90       105       115
#
# LONG: one row per unit-time, with the time point as its own variable.
#
#   country      year   gdp
#   Netherlands  2000   100
#   Netherlands  2010   120
#   Netherlands  2020   140
#   Belgium      2000    90
#   ...
#
# Neither is "correct" — they suit different jobs.
#
# You need LONG for: panel and time-series models, repeated-measures ANOVA,
# almost all plotting, and anything grouped by time.
#
# You need WIDE for: computing a change score between two waves, correlation
# matrices between items, and most human-readable output tables.
#
# The long shape is what is usually meant by "tidy data": one row per
# observation, one column per variable, one value per cell. Getting your data
# into that shape early makes everything downstream easier.

gdp_wide <- data.frame(
  country  = c("Netherlands", "Belgium", "France"),
  gdp_2000 = c(100, 90, 130),
  gdp_2010 = c(120, 105, 145),
  gdp_2020 = c(140, 115, 150)
)
gdp_wide


# --- 9.2  Wide to long, base R -----------------------------------------------

gdp_long <- reshape(
  gdp_wide,
  direction = "long",
  idvar     = "country",                                 # what identifies a unit
  varying   = c("gdp_2000", "gdp_2010", "gdp_2020"),     # columns to stack
  v.names   = "gdp",                                     # name for the values
  timevar   = "year",                                    # name for the time var
  times     = c(2000, 2010, 2020)                        # the actual time values
)
gdp_long <- gdp_long[order(gdp_long$country, gdp_long$year), ]
rownames(gdp_long) <- NULL
gdp_long


# --- 9.3  Long to wide, base R -----------------------------------------------

gdp_back <- reshape(
  gdp_long,
  direction = "wide",
  idvar     = "country",
  timevar   = "year",
  v.names   = "gdp"
)
gdp_back


# --- 9.4  The tidyr version --------------------------------------------------
#
# reshape() has a famously awkward interface. tidyr does the same job more
# readably, and you will see it in other people's code constantly.

# library(tidyr)
#
# gdp_long2 <- pivot_longer(
#   gdp_wide,
#   cols          = starts_with("gdp_"),
#   names_to      = "year",
#   names_prefix  = "gdp_",
#   values_to     = "gdp"
# )
# gdp_long2$year <- as.numeric(gdp_long2$year)   # names come back as character
#
# gdp_wide2 <- pivot_wider(
#   gdp_long2,
#   names_from  = year,
#   values_from = gdp,
#   names_prefix = "gdp_"
# )


# --- 9.5  What goes wrong ----------------------------------------------------
#
# 1. After pivoting to long, your time variable is character ("2000"), not
#    numeric. Sorting then goes alphabetical and any model treats year as a
#    category with one level per year. Always check class() after reshaping.
#
# 2. Going long to wide with a non-unique id/time combination. If a country-year
#    appears twice, R cannot decide which value to put in the cell, and you get
#    a warning and a mangled result. Check first:
#         sum(duplicated(gdp_long[, c("country", "year")]))
#
# 3. Row counts. Wide to long should multiply rows by the number of time points.
#    If it does not, something did not stack.

nrow(gdp_wide); nrow(gdp_long)     # 3 -> 9, as expected



###############################################################################
###############################################################################
#  10.  SEARCHING, SORTING, AND MERGING
###############################################################################
###############################################################################

people <- data.frame(
  id      = c(1, 2, 3, 4, 5, 6),
  name    = c("Ada", "Bram", "Chiara", "Dries", "Elif", "Femke"),
  country = c("netherlands", "belgium", "italy", "belgium", "turkey", "netherlands"),
  turnout = c(1, 0, 1, 1, 0, 1),
  income  = c(2100, 2400, NA, 3100, 2750, 2200),
  stringsAsFactors = FALSE
)


# --- 10.1  Finding rows ------------------------------------------------------

which(people$income > 2500)                  # positions of matching rows
people[which(people$income > 2500), ]        # the rows themselves

# which() vs plain logical subsetting: with NAs present, plain subsetting
# returns a row of all-NA for each missing value, while which() drops them.
people[people$income > 2500, ]               # note the NA row
people[which(people$income > 2500), ]        # clean

which.max(people$income)                     # position of the largest value
people$name[which.max(people$income)]        # who that is
range(people$income, na.rm = TRUE)


# --- 10.2  Matching against a list of values ---------------------------------
#
# %in% is the one to remember. It replaces long chains of == joined by |.

benelux <- c("netherlands", "belgium", "luxembourg")
people$country %in% benelux
people[people$country %in% benelux, ]
people[!people$country %in% benelux, ]       # everyone else

# subset() reads more naturally and handles NAs sensibly:
subset(people, income > 2500)
subset(people, country %in% benelux, select = c(name, turnout))


# --- 10.3  Searching text ----------------------------------------------------
#
# grepl() asks "does this string contain that pattern?" and returns TRUE/FALSE.

grepl("nether", people$country)                       # anywhere in the string
people[grepl("nether", people$country), ]

grepl("BELG", people$country, ignore.case = TRUE)     # ignore capitalisation

# A little pattern syntax goes a long way:
grepl("^be", people$country)     # ^ anchors to the start
grepl("nd$", people$country)     # $ anchors to the end
grep("a", people$name)           # grep() returns positions
grep("a", people$name, value = TRUE)   # ... or the matching values

# Searching variable NAMES rather than values — useful with a 300-column
# replication dataset when the codebook is unhelpful:
names(people)[grepl("inc", names(people))]

# Find and replace inside strings:
sub("netherlands", "the netherlands", people$country)   # first match per string
gsub("e", "E", people$name)                             # every match


# --- 10.4  Sorting -----------------------------------------------------------
#
# sort() sorts a vector. order() gives you the row order, which is what you need
# for a data frame — a very common confusion.

sort(people$income)                                  # just the values
people[order(people$income), ]                       # the whole table, sorted
people[order(-people$income), ]                      # descending
people[order(people$country, -people$income), ]      # by country, then income

# Sorting a data frame with sort() does not work and does not warn you clearly.
# Always use order() with the [row, ] form.


# --- 10.5  Merging two datasets ----------------------------------------------
#
# Replication almost always means joining files: survey responses to country
# indicators, wave 1 to wave 2, individuals to constituencies.

country_info <- data.frame(
  country = c("netherlands", "belgium", "italy", "spain"),
  eu_member = c(TRUE, TRUE, TRUE, TRUE),
  pop_m = c(17.5, 11.6, 59.0, 47.4),
  stringsAsFactors = FALSE
)

# Keep only rows that match in both (inner join):
merge(people, country_info, by = "country")

# Keep everything on the left, fill gaps with NA (left join) — usually what you
# want, because it makes non-matches visible instead of silently deleting them:
merged <- merge(people, country_info, by = "country", all.x = TRUE)
merged

# CHECK EVERY MERGE. Three things, every time:
nrow(people); nrow(merged)                    # 1. did the row count change?
sum(is.na(merged$pop_m))                      # 2. how many failed to match?
setdiff(people$country, country_info$country) # 3. exactly which ones, and why?

# Rows GAINED in a merge means your key is not unique on one side — every match
# gets duplicated. Rows LOST means you used an inner join and quietly deleted
# cases. Both change your sample without telling you.
#
# Most failed merges are not conceptual, they are cosmetic: "Netherlands" vs
# "netherlands", a trailing space, "UK" vs "United Kingdom". Clean the key
# variable on both sides first (section 8.3), then merge.



###############################################################################
###############################################################################
#  11.  DESCRIPTIVES AND FIRST PLOTS
###############################################################################
###############################################################################

mean(people$income, na.rm = TRUE)
median(people$income, na.rm = TRUE)
sd(people$income, na.rm = TRUE)
quantile(people$income, na.rm = TRUE)

table(people$country)                          # counts
table(people$country, people$turnout)          # cross-tabulation
prop.table(table(people$country))              # proportions
round(prop.table(table(people$country, people$turnout), margin = 1), 2)  # row %

tapply(people$income, people$country, mean, na.rm = TRUE)   # statistic per group
aggregate(income ~ country, data = people, FUN = mean)      # same, as a table

# Always plot a variable before you model it. A summary statistic can hide a
# shape that changes your conclusion completely — the point of the Wainer
# reading in week 3.

hist(people$income, main = "Income distribution", xlab = "Monthly income (EUR)")
boxplot(income ~ country, data = people, main = "Income by country", ylab = "EUR")
plot(people$id, people$income, main = "Income by respondent",
     xlab = "Respondent ID", ylab = "Monthly income (EUR)")

# Label every axis. An unlabelled plot is not a finding, it is a doodle.



###############################################################################
###############################################################################
#  12.  READING ERROR MESSAGES
###############################################################################
###############################################################################

# R's errors look hostile but are fairly specific. The ones you will meet first:
#
#   Error: object 'x' not found
#       You never created x, you misspelled it, or you capitalised it
#       differently. Also: you skipped the line that creates it. Check the
#       Environment pane for the real name.
#
#   Error: could not find function "read_excel"
#       Typo, or the package is not loaded. Did you run library() this session?
#
#   Error in file(...): cannot open the connection
#       Wrong folder or wrong filename. Check getwd() and list.files().
#
#   Error in data.frame(...): arguments imply differing number of rows
#       Your vectors are different lengths.
#
#   undefined columns selected
#       You asked for a column that does not exist — often a [ ] with the comma
#       in the wrong place.
#
#   + at the start of the console line, and nothing runs
#       R is waiting: an unclosed bracket or quotation mark. Press Esc, then
#       look for the missing ) or ".
#
# A WARNING is not an ERROR. An error means nothing ran. A warning means
# something ran but R is uneasy about it — "NAs introduced by coercion" is a
# warning, and it is telling you that data just silently became missing.
# Read your warnings.
#
# And the hardest category: code that runs fine and gives the wrong answer.
# No message will save you there. Only checking will — dim(), summary(),
# table(), and a plot.



###############################################################################
###############################################################################
#  13.  WHERE TO GO NEXT
###############################################################################
###############################################################################

# Practice worksheet: qrm_practice_spot_the_mistake.qmd
#   Broken code to diagnose and repair, with space to type your answers. Render
#   it, or open the HTML version, and work through it before seminar 2.
#
# Reference:
#   ?function_name and the Examples section at the bottom of any help page
#   RStudio cheat sheets: Help > Cheat Sheets
#   R for Data Science (free, online) for the tidyverse approach
#
# Course datasets are on the Datasets page of the course site.

sessionInfo()   # your R version and loaded packages — include this whenever you
                # ask anyone for help

###############################################################################
# End of script.
# Questions: l.zicha@luc.leidenuniv.nl
###############################################################################
