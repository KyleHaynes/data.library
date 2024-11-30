# data.library

**!!! IN DEVELOPMENT !!!**

### Simple R library to input and output datasets.

* Data (`data.table`) is outputted (`output()`) as individual RDS objects.
* Data is inputted (`input()`) as a combined `data.table` object.
* Ability to specify a subset of variables to input.

### Usage

```R
# Install package.
remotes::install_github("KyleHaynes/data.library")
# or
devtools::install_github("KyleHaynes/data.library")
# and
install.packages("data.table")

# Load required packages
library(data.library)
library(data.table)

# Output mtcars.
output(data.table(mtcars), "./mtcars")

# Input mtcars.
input("./mtcars")

# Input a subset of variables.
input("./mtcars", vars_regex = "c|w")
# ℹ Importing the following variables: "carb", "cyl", "qsec", and "wt".
# ! Not importing the following variables: "am", "disp", "drat", "gear", "hp", "mpg", and "vs".
# ℹ Imported `carb`` in 0 minutes.
# ℹ Imported `cyl`` in 0 minutes.
# ℹ Imported `qsec`` in 0 minutes.
# ℹ Imported `wt`` in 0 minutes.
# ℹ Folder last modified: 2024-12-01 05:43:10.138605.
# ℹ Overall time taken: 0 minutes.
```

### Why not `feather`?

* Network benchmarks (~100MB/s) indicate reading RDS is faster.
* `feather` can't output complex data structures (e.g. lists).

(basic, basic, basic) benchmarks (GNAF-Core, 15.4m rows, 27 vars):

```R
system.time({
    x <- read_feather("\\\\Server\\9tb\\New folder\\gnaf.feather", columns = c("ADDRESS_DETAIL_PID", "DATE_CREATED", "ADDRESS_LABEL"))
}, gcFirst = F)
# 32 seconds

system.time({
    d <- input("\\\\Server\\9tb\\New folder\\gnap", vars_vec = c("ADDRESS_DETAIL_PID", "DATE_CREATED", "ADDRESS_LABEL"))
}, gcFirst = F)
# 23 seconds

system.time({
    x <- read_feather("\\\\Server\\9tb\\New folder\\gnaf.feather")
}, gcFirst = F)
# 97 seconds

system.time({
    d <- input("\\\\Server\\9tb\\New folder\\gnap")
}, gcFirst = F)
# 90 seconds
```

### To Do

- Lots
- Allow non-data.tables
- Streamlined creation of metadata
- Better doco
- Vignettes