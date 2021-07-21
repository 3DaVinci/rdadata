
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

``` r
library(rdadata)
# Save tokens to pass them only one time
save_dadata_tokens(api_token = "Replace with Dadata API key",
                   secret_token = "Replace with Dadata secret key")
```

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

### [Geocode address](https://dadata.ru/api/geocode/)

``` r
call <- clean(method = "geocode", query = "мск сухонская 11")
str(call)

tibble [1 × 82] (S3: tbl_df/tbl/data.frame)
 $ source                 : chr "мск сухонская 11s"
 $ result                 : chr "г Москва, ул Сухонская, д 11"
 $ postal_code            : chr "127642"
 $ country                : chr "Россия"
 $ country_iso_code       : chr "RU"
 $ federal_district       : chr "Центральный"
 ...
```

### [Reverse geocode address](https://dadata.ru/api/geolocate/)

``` r
> call <- locate(method = "geo", lat = 55.878, lon = 37.653)
> str(call)

tibble [5 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr [1:5] "г Москва, ул Сухонская, д 11" ...
 $ unrestricted_value          : chr [1:5] "127642, г Москва, ул Сухонская, д 11" ...
 $ data.postal_code            : chr [1:5] "127642" "127642" "127642" "127642" ...
 $ data.country                : chr [1:5] "Россия" "Россия" "Россия" "Россия" ...
 $ data.country_iso_code       : chr [1:5] "RU" "RU" "RU" "RU" ...
 ...
```

### [GeoIP city](https://dadata.ru/api/iplocate/)

``` r
> call <- locate(method = "ip", ip = "46.226.227.20")
> str(call)

tibble [1 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr "г Краснодар"
 $ unrestricted_value          : chr "350000, Краснодарский край, г Краснодар"
 $ data.postal_code            : chr "350000"
 $ data.country                : chr "Россия"
 $ data.country_iso_code       : chr "RU"
 $ data.federal_district       : chr "Южный"
```

### [Autocomplete (suggest) address](https://dadata.ru/api/suggest/address/)

``` r
> call <- suggest(method = "address", query = "самара метал")
> str(call)

tibble [10 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr [1:10] "г Самара, пр-кт Металлургов" ...
 $ unrestricted_value          : chr [1:10] "Самарская обл, г Самара, пр-кт Металлургов" ...
 $ data.postal_code            : chr [1:10] NA NA NA NA ...
 $ data.country                : chr [1:10] "Россия" "Россия" "Россия" "Россия" ...
 $ data.country_iso_code       : chr [1:10] "RU" "RU" "RU" "RU" ...
 ...
```

Show suggestions in English:

``` r
> call <- suggest(method = "address", query = "самара метал", language = "en")
> str(call)

tibble [10 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr [1:10] "Russia, gorod Samara, prospekt Metallurgov" ...
 $ unrestricted_value          : chr [1:10] "Russia, oblast Samarskaya, gorod Samara, prospekt Metallurgov" ...
 $ data.postal_code            : chr [1:10] NA NA NA NA ...
 $ data.country                : chr [1:10] "Russia" "Russia" "Russia" "Russia" ...
 $ data.country_iso_code       : chr [1:10] "RU" "RU" "RU" "RU" ...
 ...
```

Constrain by city (Yuzhno-Sakhalinsk):

``` r
> call <- suggest(method = "address", query = "Ватутина", locations = list(kladr_id = "6500000100000"))
> str(call)

tibble [1 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr "г Южно-Сахалинск, ул Ватутина"
 $ unrestricted_value          : chr "693022, Сахалинская обл, г Южно-Сахалинск, ул Ватутина"
 $ data.postal_code            : chr "693022"
 $ data.country                : chr "Россия"
 $ data.country_iso_code       : chr "RU"
 $ data.federal_district       : chr "Дальневосточный"
 $ data.region_fias_id         : chr "aea6280f-4648-460f-b8be-c2bc18923191"
 ...
```

Constrain by specific geo point and radius (in Vologda city):

``` r
> call <- suggest(method = "address", query = "сухонская", 
                  locations_geo = list(lat = 59.244634,  lon = 39.913355, radius_meters = 200))
> str(call)

tibble [9 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr [1:9] "г Вологда, ул Сухонская" "г Вологда, ул Сухонская, д 8" ...
 $ unrestricted_value          : chr [1:9] "160019, Вологодская обл, г Вологда, ул Сухонская" ...
 $ data.postal_code            : chr [1:9] "160019" "160019" "160019" "160019" ...
 $ data.country                : chr [1:9] "Россия" "Россия" "Россия" "Россия" ...
 $ data.country_iso_code       : chr [1:9] "RU" "RU" "RU" "RU" ...
 $ data.federal_district       : logi [1:9] NA NA NA NA NA NA ...
 $ data.region_fias_id         : chr [1:9] "ed36085a-b2f5-454f-b9a9-1c9a678ee618"...
 ...
```

Boost city to top (Toliatti):

``` r
> call <- suggest(method = "address", query = "авто", 
                  locations_boost = list(kladr_id = "6300000700000"))
> str(call)

tibble [10 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr [1:10] "Самарская обл, г Тольятти, Автозаводское шоссе" ...
 $ unrestricted_value          : chr [1:10] "445004, Самарская обл, г Тольятти, Автозаводское шоссе" ...
 $ data.postal_code            : chr [1:10] "445004" "445092" NA "443110" ...
 $ data.country                : chr [1:10] "Россия" "Россия" "Россия" "Россия" ...
 ...
```

### [Find address by FIAS ID](https://dadata.ru/api/find-address/)

``` r
> call <- find_by_id(method = "address", query = "9120b43f-2fae-4838-a144-85e43c2bfb29")
> str(call)

tibble [1 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr "г Москва, ул Снежная"
 $ unrestricted_value          : chr "129323, г Москва, р-н Свиблово, ул Снежная"
 $ data.postal_code            : chr "129323"
 $ data.country                : chr "Россия"
 $ data.country_iso_code       : chr "RU"
 $ data.federal_district       : chr "Центральный"
 $ data.region_fias_id         : chr "0c5b2444-70a0-4932-980c-b4dc0d3f02b5"
 ...
```
