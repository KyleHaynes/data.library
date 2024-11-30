# data.library

**!!! IN DEVELOPMENT !!!**

### Simple R library to input and output datasets.

* Data (`data.table`) is outputted (`output()`) as individual RDS objects 
* Data is inputted (`input()`) as a combined `data.table` object
* Ability to specify a subset of variables to input.

### Usage

```R
# Install package.
remotes::install_github("KyleHaynes/data.library")
# or
devtools::install_github("KyleHaynes/data.library")

# Load package
library(data.library)

# Output mtcars.
output(data.table(mtcars), "./mtcars")

# Input mtcars.
input("./mtcars")

```

### Why not `feather`?

* Network benchmarks (~100MB/s) indicate reading RDS is faster.

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