
# sampledblib.r

<!-- badges: start -->
<!-- badges: end -->

sampledblib.r provides an R wrapper around the python package [sampledblib](https://github.com/m-murphy/sampledblib)

## Installation

You can install the development version of sampledblib.r from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("m-murphy/sampledblib.r")


# install the python package
sampledblib.r::install_sampledblib()
```


## Example

``` r
library(sampledblib.r)

# optionally activate your virtualenvironment
reticulate::use_virtualenv("your_venv")

# set your sql connection string
options("sampledblib.db.location" = "sqlite:///path_to_sqlite.sqlite")

# set your date format
options("sampledblib.fm.date_format" = "%d-%b-%Y")

# initialize your sampledb
initialize_sampledb()

# get all studies
studies <- get_studies()

```

