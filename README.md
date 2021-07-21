
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rdadata<img src="man/figures/logo.png" align="right" height=140/>

## Objective

The **rdadata** package provides the rich functionality of [DaData REST
API](https://dadata.ru/api/) to R users, without the need to write
functional queries to each method. We did it for you.

In this way, users benefit from the best features of both platforms.
More specifically, the package is a wrapper around [DaData REST
API](https://dadata.ru/api/), allowing users to easily integrate with
DaData methods.

<figure>
<img src="man/figures/wrangle.png" style="width:469px;height=184px">
<figcaption>
<a href="https://r4ds.had.co.nz/"><i>Source: R For Data Science - Hadley
Wickham</i></a>
</figcaption>
</figure>

The focus of this package lies in the following workflow aspects:

-   **Import** — the
    [httr](https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html)
    package will help us with this
-   **Tidy** — [dplyr](https://dplyr.tidyverse.org/),
    [magrittr](https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html)
    and
    [tidyjson](https://cran.r-project.org/web/packages/tidyjson/vignettes/introduction-to-tidyjson.html)

Hence, for easy transformation and manipulation, main functions, related
with getting DaData returns a `tibble` with **tidy data**, following
main rules where each row is a single observation, each column is a
variable and each value must have its own cell. Thus, it integrates well
with `dplyr` and tidy paradigm. This also allows for an easy integration
with tabular data, but if it necessary, you may manipulate with raw
JSON, saved as nested list.

## Installation

You can install the latest release of this package from
[Github](https://github.com/3davinci/rdadata) with the following
commands in `R`:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("3davinci/rdadata")
```

## Usage

Go to your profile on DaData and copy API token and secret token. Then
set it with `save_dadata_tokens()`

    library(rdadata)
    # Save tokens to pass them only one time
    save_dadata_tokens(api_token = "Replace with Dadata API key",
                       secret_token = "Replace with Dadata secret key")

## Postal Address

### [Validate and cleanse address](https://dadata.ru/api/clean/address/)

``` r
call <- clean(method = "address", query = "мск сухонская 11 89")
str(call)
tibble [1 × 82] (S3: tbl_df/tbl/data.frame)
 $ source                 : chr "мск сухонская 11 89"
 $ result                 : chr "г Москва, ул Сухонская, д 11, кв 89"
 $ postal_code            : chr "127642"
 $ country                : chr "Россия"
 $ country_iso_code       : chr "RU"
 $ federal_district       : chr "Центральный"
 ...
```
