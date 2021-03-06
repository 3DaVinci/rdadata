
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
 ...
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

Find by KLADR ID:

``` r
> call <- find_by_id(method = "address", query = "77000000000268400")
> str(call)

tibble [1 × 88] (S3: tbl_df/tbl/data.frame)
 $ value                       : chr "г Москва, ул Снежная"
 $ unrestricted_value          : chr "129323, г Москва, р-н Свиблово, ул Снежная"
 $ data.postal_code            : chr "129323"
 $ data.country                : chr "Россия"
 $ data.country_iso_code       : chr "RU"
 $ data.federal_district       : chr "Центральный"
 ...
```

### [Find postal office](https://dadata.ru/api/suggest/postal_unit/)

Suggest postal office by address or code:

``` r
> call <- suggest(method = "postal_unit", query = "дежнева 2а")
> str(call)

tibble [1 × 17] (S3: tbl_df/tbl/data.frame)
 $ value                : chr "127642"
 $ unrestricted_value   : chr "г Москва, проезд Дежнёва, д 2А"
 $ data.postal_code     : chr "127642"
 $ data.is_closed       : logi FALSE
 $ data.type_code       : chr "ГОПС"
 ...
```

Find postal office by code:

``` r
> call <- find_by_id(method = "postal_unit", query = "127642")
> str(call)

tibble [1 × 17] (S3: tbl_df/tbl/data.frame)
 $ value                : chr "127642"
 $ unrestricted_value   : chr "г Москва, проезд Дежнёва, д 2А"
 $ data.postal_code     : chr "127642"
 $ data.is_closed       : logi FALSE
 $ data.type_code       : chr "ГОПС"
 $ data.address_str     : chr "г Москва, проезд Дежнёва, д 2А"
 $ data.address_kladr_id: chr "7700000000000"
 ...
```

### [Get City ID for delivery services](https://dadata.ru/api/delivery/)

``` r
> call <- find_by_id(method = "delivery", query = "3100400100000")
> str(call)

tibble [1 × 7] (S3: tbl_df/tbl/data.frame)
 $ value             : chr "3100400100000"
 $ unrestricted_value: chr "fe7eea4a-875a-4235-aa61-81c2a37a0440"
 $ data.kladr_id     : chr "3100400100000"
 $ data.fias_id      : chr "fe7eea4a-875a-4235-aa61-81c2a37a0440"
 $ data.boxberry_id  : chr "01929"
 $ data.cdek_id      : chr "344"
 $ data.dpd_id       : chr "196006461"
```

### [Get address strictly according to FIAS](https://dadata.ru/api/find-fias/)

``` r
> call <- find_by_id(method = "fias", query = "9120b43f-2fae-4838-a144-85e43c2bfb29")
> str(call)

tibble [1 × 66] (S3: tbl_df/tbl/data.frame)
 $ value                            : chr "г Москва, ул Снежная"
 $ unrestricted_value               : chr "129323, г Москва, ул Снежная"
 $ data.postal_code                 : chr "129323"
 $ data.region_fias_id              : chr "0c5b2444-70a0-4932-980c-b4dc0d3f02b5"
 $ data.region_kladr_id             : chr "7700000000000"
 $ data.region_with_type            : chr "г Москва"
 $ data.region_type                 : chr "г"
 $ data.region_type_full            : chr "город"
 $ data.region                      : chr "Москва"
 ...
```

### [Suggest country](https://dadata.ru/api/suggest/country/)

``` r
> call <- suggest(method = "country", query = "та")
> str(call)

tibble [4 × 7] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:4] "Таджикистан" "Таиланд" "Тайвань" "Танзания"
 $ unrestricted_value: chr [1:4] "Республика Таджикистан" "Королевство Таиланд" ...
 $ data.code         : chr [1:4] "762" "764" "158" "834"
 $ data.alfa2        : chr [1:4] "TJ" "TH" "TW" "TZ"
 $ data.alfa3        : chr [1:4] "TJK" "THA" "TWN" "TZA"
 $ data.name_short   : chr [1:4] "Таджикистан" "Таиланд" "Тайвань" "Танзания"
 $ data.name         : chr [1:4] "Республика Таджикистан" "Королевство Таиланд"...
 ...
```

## Company or individual enterpreneur

### [Find company by INN](https://dadata.ru/api/find-party/)

``` r
> call <- find_by_id(method = "party", query = "7707083893", count = 300)
> str(call)

tibble [108 × 176] (S3: tbl_df/tbl/data.frame)
 $ value                                          : chr [1:108] "ПАО СБЕРБАНК" "БАЙКАЛЬСКИЙ БАНК ПАО СБЕРБАНК" "ДАЛЬНЕВОСТОЧНЫЙ БАНК ПАО СБЕРБАНК" "ЗАПАДНО-СИБИРСКОЕ ОТДЕЛЕНИЕ №8647" ...
 $ unrestricted_value                             : chr [1:108] "ПАО СБЕРБАНК" "БАЙКАЛЬСКИЙ БАНК ПАО СБЕРБАНК" "ДАЛЬНЕВОСТОЧНЫЙ БАНК ПАО СБЕРБАНК" "ЗАПАДНО-СИБИРСКОЕ ОТДЕЛЕНИЕ №8647" ...
 $ data.kpp                                       : chr [1:108] "773601001" "380843001" "272143001" "720302020" ...
 $ data.predecessors                              : logi [1:108] NA NA NA NA NA NA ...
 $ data.successors                                : logi [1:108] NA NA NA NA NA NA ...
 $ data.branch_type                               : chr [1:108] "MAIN" "BRANCH" "BRANCH" "BRANCH" ...
 $ data.branch_count                              : num [1:108] 87 0 0 0 0 0 0 0 0 0 ...
 ...
```

Find by INN and KPP:

``` r
> call <- find_by_id(method = "party", query = "7707083893", kpp = "540602001")
> str(call)

tibble [1 × 140] (S3: tbl_df/tbl/data.frame)
 $ value                                    : chr "СИБИРСКИЙ БАНК ПАО СБЕРБАНК"
 $ unrestricted_value                       : chr "СИБИРСКИЙ БАНК ПАО СБЕРБАНК"
 $ data.kpp                                 : chr "540602001"
 $ data.capital                             : logi NA
 $ data.management                          : logi NA
```

### [Suggest company](https://dadata.ru/api/suggest/party/)

You can variate `count` parameter, by default it’s 10.

``` r
> call <- suggest(method = "party", query = "сбер")
> str(call)

tibble [10 × 143] (S3: tbl_df/tbl/data.frame)
 $ value                                    : chr [1:10] "ПАО СБЕРБАНК" "АО \"СБЕРЭНЕРГОСЕРВИС-ЮГРА\"" "АО \"СБЕРБРОКЕР\"" "АО \"СБЕРИНВЕСТКАПИТАЛ\"" ...
 $ unrestricted_value                       : chr [1:10] "ПАО СБЕРБАНК" "АО \"СБЕРЭНЕРГОСЕРВИС-ЮГРА\"" "АО \"СБЕРБРОКЕР\"" "АО \"СБЕРИНВЕСТКАПИТАЛ\"" ...
 $ data.kpp                                 : chr [1:10] "773601001" "861501001" "772601001" "773101001" ...
 ...
```

Constrain by specific regions (Saint Petersburg and Leningradskaya
oblast):

``` r
> call <- suggest(method = "party", query = "сбер", 
                  locations = list(kladr_id = "7800000000000" , 
                                   kladr_id = "4700000000000"))
> str(call)

tibble [10 × 151] (S3: tbl_df/tbl/data.frame)
 $ value                                    : chr [1:10] "ООО \"СБЕРГЛАВСТРОЙ\"" "ООО \"СБЕРМЕД\"" "ООО \"СБЕРТЕК\"" "ООО \"СБЕРЭНЕРГИЯ\"" ...
 $ unrestricted_value                       : chr [1:10] "ООО \"СБЕРГЛАВСТРОЙ\"" "ООО \"СБЕРМЕД\"" "ООО \"СБЕРТЕК\"" "ООО \"СБЕРЭНЕРГИЯ\"" ...
 $ data.kpp                                 : chr [1:10] "781401001" "781301001" "783901001" "781001001" ...
 ...
```

Constrain by active companies:

``` r
> call <- suggest(method = "party", query = "сбер", status = "ACTIVE")
> str(call)

tibble [10 × 143] (S3: tbl_df/tbl/data.frame)
 $ value                                    : chr [1:10] "ПАО СБЕРБАНК" "АО \"СБЕРБРОКЕР\"" "АО \"СБЕРИНВЕСТКАПИТАЛ\"" "АО \"СБЕРТЕХ\"" ...
 $ unrestricted_value                       : chr [1:10] "ПАО СБЕРБАНК" "АО \"СБЕРБРОКЕР\"" "АО \"СБЕРИНВЕСТКАПИТАЛ\"" "АО \"СБЕРТЕХ\"" ...
 $ data.kpp                                 : chr [1:10] "773601001" "772601001" "773101001" "772601001" ...
 ...
```

Constrain by individual entrepreneurs:

``` r
suggest(method = "party", query = "сбер", type="INDIVIDUAL")
```

Constrain by head companies, no branches:

``` r
suggest(method = "party", query = "сбер", branch_type="MAIN")
```

### [Find affiliated companies](https://dadata.ru/api/find-affiliated/)

``` r
> call <- suggest(method = "find_affiliated", query = "7736207543")
> str(call)

tibble [10 × 48] (S3: tbl_df/tbl/data.frame)
 $ value                          : chr [1:10] "ООО \"ДЗЕН.ПЛАТФОРМА\"" "ООО \"ЕДАДИЛ\"" "ООО \"ЗНАНИЕ\"" "ООО \"К50\"" ...
 $ unrestricted_value             : chr [1:10] "ООО \"ДЗЕН.ПЛАТФОРМА\"" "ООО \"ЕДАДИЛ\"" "ООО \"ЗНАНИЕ\"" "ООО \"К50\"" ...
 $ data.kpp                       : chr [1:10] "770501001" "770401001" "770401001" "773101001" ...
 ...
```

Search only by manager INN:

``` r
> call <- suggest(method = "find_affiliated", query = "773006366201", scope = "MANAGERS")
> str(call)

tibble [3 × 48] (S3: tbl_df/tbl/data.frame)
 $ value                          : chr [1:3] "ООО \"ЯНДЕКС\"" "МФ \"ФОИ\"" "АНО ДПО \"ШАД\""
 $ unrestricted_value             : chr [1:3] "ООО \"ЯНДЕКС\"" "МФ \"ФОИ\"" "АНО ДПО \"ШАД\""
 $ data.kpp                       : chr [1:3] "770401001" "390601001" "770401001"
 ...
```

## Bank

### [Find bank by BIC, SWIFT or INN](https://dadata.ru/api/find-bank/)

``` r
> call <- find_by_id(method = "bank", query = "044525225")
> str(call)

tibble [1 × 137] (S3: tbl_df/tbl/data.frame)
 $ value                                    : chr "ПАО Сбербанк"
 $ unrestricted_value                       : chr "ПАО Сбербанк"
 $ data.bic                                 : chr "044525225"
 $ data.swift                               : chr "SABRRUMM012"
 $ data.inn                                 : chr "7707083893"
 $ data.kpp                                 : chr "773601001"
 $ data.okpo                                : logi NA
 $ data.correspondent_account               : chr "30101810400000000225"
 ...
```

Find by SWIFT code:

``` r
> find_by_id(method = "bank", query = "SABRRUMM")
```

Find by INN:

``` r
> find_by_id(method = "bank", query = "7728168971")
```

Find by INN and KPP:

``` r
> find_by_id(method = "bank", query = "7728168971", kpp = "667102002")
```

Find by registration number:

``` r
> find_by_id(method = "bank", query = "1481")
```

### [Suggest bank](https://dadata.ru/api/suggest/bank/)

``` r
> call <- suggest(method = "bank", query = "ти")
> str(call)

tibble [8 × 113] (S3: tbl_df/tbl/data.frame)
 $ value                                    : chr [1:8] "АО «Тимер Банк»" "АО «Тинькофф Банк»" "«Азиатско-Тихоокеанский Банк» (АО)" "Джей энд Ти Банк (АО)" ...
 $ unrestricted_value                       : chr [1:8] "АО «Тимер Банк»" "АО «Тинькофф Банк»" "«Азиатско-Тихоокеанский Банк» (АО)" "Джей энд Ти Банк (АО)" ...
 $ data.bic                                 : chr [1:8] "044525567" "044525974" "041012765" "044525588" ...
 $ data.swift                               : chr [1:8] "TIMERU2K" "TICSRUMMXXX" "ASANRU8XXXX" "TRRYRUMMXXX" ...
 $ data.inn                                 : chr [1:8] "1653016689" "7710140679" "2801023444" "7713001271" ...
 $ data.kpp                                 : chr [1:8] "770501001" "773401001" "280101001" "770601001" ...
 ...
```

## Personal name

### [Validate and cleanse name](https://dadata.ru/api/clean/name/)

``` r
> call <- clean(method = "name", query = "Срегей владимерович иванов")
> str(call)

tibble [1 × 10] (S3: tbl_df/tbl/data.frame)
 $ source         : chr "Срегей владимерович иванов"
 $ result         : chr "Иванов Сергей Владимирович"
 $ result_genitive: chr "Иванова Сергея Владимировича"
 $ result_dative  : chr "Иванову Сергею Владимировичу"
 $ result_ablative: chr "Ивановым Сергеем Владимировичем"
 $ surname        : chr "Иванов"
 $ name           : chr "Сергей"
 $ patronymic     : chr "Владимирович"
 $ gender         : chr "М"
 $ qc             : num 1
```

### [Suggest name](https://dadata.ru/api/suggest/name/)

``` r
> call <- suggest(method = "fio", query = "викт")
> str(call)

tibble [10 × 8] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:10] "Виктор" "Виктория" "Викторова" "Викторов" ...
 $ unrestricted_value: chr [1:10] "Виктор" "Виктория" "Викторова" "Викторов" ...
 $ data.surname      : chr [1:10] NA NA "Викторова" "Викторов" ...
 $ data.name         : chr [1:10] "Виктор" "Виктория" NA NA ...
 $ data.patronymic   : logi [1:10] NA NA NA NA NA NA ...
 $ data.gender       : chr [1:10] "MALE" "FEMALE" "FEMALE" "MALE" ...
 $ data.source       : logi [1:10] NA NA NA NA NA NA ...
 $ data.qc           : chr [1:10] "0" "0" "0" "0" ...
```

Suggest female first name:

``` r
> call <- suggest(method = "fio", query = "викт", parts = "NAME", gender = "FEMALE")
> str(call)
tibble [2 × 8] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:2] "Виктория" "Викторина"
 $ unrestricted_value: chr [1:2] "Виктория" "Викторина"
 $ data.surname      : logi [1:2] NA NA
 $ data.name         : chr [1:2] "Виктория" "Викторина"
 $ data.patronymic   : logi [1:2] NA NA
 $ data.gender       : chr [1:2] "FEMALE" "FEMALE"
 $ data.source       : logi [1:2] NA NA
 $ data.qc           : chr [1:2] "0" "0"
```

## Phone

### [Validate and cleanse phone](https://dadata.ru/api/clean/phone/)

``` r
> call <- clean(method = "phone", query = "9168-233-454")
> str(call)

tibble [1 × 14] (S3: tbl_df/tbl/data.frame)
 $ source      : chr "9168-233-454"
 $ type        : chr "Мобильный"
 $ phone       : chr "+7 916 823-34-54"
 $ country_code: chr "7"
 $ city_code   : chr "916"
 $ number      : chr "8233454"
 $ extension   : logi NA
 $ provider    : chr "ООО \"Т2 Мобайл\""
 $ country     : chr "Россия"
 $ region      : chr "Москва и Московская область"
 $ city        : logi NA
 $ timezone    : chr "UTC+3"
 $ qc_conflict : num 0
 $ qc          : num 0
```

## Passport

### [Validate passport](https://dadata.ru/api/clean/passport/)

``` r
> call <- clean(method = "passport", query = "4509 235857")
> str(call)

tibble [1 × 4] (S3: tbl_df/tbl/data.frame)
 $ source: chr "4509 235857"
 $ series: chr "45 09"
 $ number: chr "235857"
 $ qc    : num 0
```

### [Suggest issued by](https://dadata.ru/api/suggest/fms_unit/)

``` r
> call <- suggest(method = "fms_unit", query = "772 053")
> str(call)

tibble [8 × 6] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:8] "ОВД ЗЮЗИНО Г. МОСКВЫ" "ОВД ЗЮЗИНО Г. МОСКВЫ ПАСПОРТНЫЙ СТОЛ 1" "ОВД ЗЮЗИНО ПС УВД ЮЗАО Г. МОСКВЫ" "ОВД ЗЮЗИНО ПС № 1 УВД ЮЗАО Г. МОСКВЫ" ...
 $ unrestricted_value: chr [1:8] "ОВД ЗЮЗИНО Г. МОСКВЫ" "ОВД ЗЮЗИНО Г. МОСКВЫ ПАСПОРТНЫЙ СТОЛ 1" "ОВД ЗЮЗИНО ПС УВД ЮЗАО Г. МОСКВЫ" "ОВД ЗЮЗИНО ПС № 1 УВД ЮЗАО Г. МОСКВЫ" ...
 $ data.code         : chr [1:8] "772-053" "772-053" "772-053" "772-053" ...
 $ data.name         : chr [1:8] "ОВД ЗЮЗИНО Г. МОСКВЫ" "ОВД ЗЮЗИНО Г. МОСКВЫ ПАСПОРТНЫЙ СТОЛ 1" "ОВД ЗЮЗИНО ПС УВД ЮЗАО Г. МОСКВЫ" "ОВД ЗЮЗИНО ПС № 1 УВД ЮЗАО Г. МОСКВЫ" ...
 $ data.region_code  : chr [1:8] "77" "77" "77" "77" ...
 $ data.type         : chr [1:8] "2" "2" "2" "2" ...
```

## Email

### [Validate email](https://dadata.ru/api/clean/email/)

``` r
> call <- clean(method = "email", query = "serega@yandex/ru")
> str(call)

tibble [1 × 6] (S3: tbl_df/tbl/data.frame)
 $ source: chr "serega@yandex/ru"
 $ email : chr "serega@yandex.ru"
 $ local : chr "serega"
 $ domain: chr "yandex.ru"
 $ type  : chr "PERSONAL"
 $ qc    : num 4
```

### [Suggest email](https://dadata.ru/api/suggest/email/)

``` r
> call <- suggest(method = "email", query = "maria@")
> str(call)

tibble [10 × 7] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:10] "maria@mail.ru" "maria@bk.ru" "maria@mail.ua" "maria@internet.ru" ...
 $ unrestricted_value: chr [1:10] "maria@mail.ru" "maria@bk.ru" "maria@mail.ua" "maria@internet.ru" ...
 $ data.local        : chr [1:10] "maria" "maria" "maria" "maria" ...
 $ data.domain       : chr [1:10] "mail.ru" "bk.ru" "mail.ua" "internet.ru" ...
 $ data.type         : logi [1:10] NA NA NA NA NA NA ...
 $ data.source       : logi [1:10] NA NA NA NA NA NA ...
 $ data.qc           : logi [1:10] NA NA NA NA NA NA ...
```

## Other datasets

### [Tax office](https://dadata.ru/api/suggest/fns_unit/)

``` r
> call <- find_by_id(method = "fns_unit", query = "5257")
> str(call)

tibble [1 × 21] (S3: tbl_df/tbl/data.frame)
 $ value                          : chr "Межрайонная инспекция ФНС России № 19 по Нижегородской области"
 $ unrestricted_value             : chr "Межрайонная инспекция ФНС России № 19 по Нижегородской области"
 $ data.code                      : chr "5257"
 $ data.name                      : chr "Межрайонная инспекция ФНС России № 19 по Нижегородской области"
 $ data.name_short                : chr "Межрайонная инспекция ФНС России № 19 по Нижегородской области"
 $ data.address                   : chr ",603011,,,Нижний Новгород г,,Искры ул,1,,"
 $ data.phone                     : chr "831 432-65-65, факс: 432-65-66"
 ...
```

### [Regional court](https://dadata.ru/api/suggest/region_court/)

``` r
> call <- suggest(method = "region_court", query = "таганско")
> str(call)

tibble [5 × 5] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:5] "Судебный участок № 371 Таганского судебного района г. Москвы" "Судебный участок № 372 Таганского судебного района г. Москвы" "Судебный участок № 373 Таганского судебного района г. Москвы" "Судебный участок № 374 Таганского судебного района г. Москвы" ...
 $ unrestricted_value: chr [1:5] "Судебный участок № 371 Таганского судебного района г. Москвы" "Судебный участок № 372 Таганского судебного района г. Москвы" "Судебный участок № 373 Таганского судебного района г. Москвы" "Судебный участок № 374 Таганского судебного района г. Москвы" ...
 $ data.code         : chr [1:5] "77MS0371" "77MS0372" "77MS0373" "77MS0374" ...
 $ data.name         : chr [1:5] "Судебный участок № 371 Таганского судебного района г. Москвы" "Судебный участок № 372 Таганского судебного района г. Москвы" "Судебный участок № 373 Таганского судебного района г. Москвы" "Судебный участок № 374 Таганского судебного района г. Москвы" ...
 $ data.region_code  : chr [1:5] "77" "77" "77" "77" ...
```

### [Metro station](https://dadata.ru/api/suggest/metro/)

``` r
> call <- suggest(method = "metro", query = "алек")
> str(call)

tibble [4 × 12] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:4] "Александровский сад" "Алексеевская" "Площадь Александра Невского 1" "Площадь Александра Невского 2"
 $ unrestricted_value: chr [1:4] "Александровский сад (Филёвская)" "Алексеевская (Калужско-Рижская)" "Площадь Александра Невского 1 (Невско-Василеостровская)" "Площадь Александра Невского 2 (Правобережная)"
 $ data.city_kladr_id: chr [1:4] "7700000000000" "7700000000000" "7800000000000" "7800000000000"
 $ data.city_fias_id : chr [1:4] "0c5b2444-70a0-4932-980c-b4dc0d3f02b5" "0c5b2444-70a0-4932-980c-b4dc0d3f02b5" "c2deb16a-0330-4f05-821f-1d09c93331e6" "c2deb16a-0330-4f05-821f-1d09c93331e6"
 $ data.city         : chr [1:4] "Москва" "Москва" "Санкт-Петербург" "Санкт-Петербург"
 $ data.name         : chr [1:4] "Александровский сад" "Алексеевская" "Площадь Александра Невского 1" "Площадь Александра Невского 2"
 $ data.line_id      : chr [1:4] "4" "6" "3" "4"
 $ data.line_name    : chr [1:4] "Филёвская" "Калужско-Рижская" "Невско-Василеостровская" "Правобережная"
 $ data.geo_lat      : num [1:4] 55.8 55.8 59.9 59.9
 $ data.geo_lon      : num [1:4] 37.6 37.6 30.4 30.4
 $ data.color        : chr [1:4] "1EBCEF" "F07E24" "009A49" "EA7125"
 $ data.is_closed    : logi [1:4] FALSE FALSE FALSE FALSE
```

Constrain by city (Saint Petersburg):

``` r
> call <- suggest(method = "metro", query = "алек", filters = list(city = "Санкт-Петербург"))
> str(call)

tibble [2 × 12] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:2] "Площадь Александра Невского 1" "Площадь Александра Невского 2"
 $ unrestricted_value: chr [1:2] "Площадь Александра Невского 1 (Невско-Василеостровская)" "Площадь Александра Невского 2 (Правобережная)"
 $ data.city_kladr_id: chr [1:2] "7800000000000" "7800000000000"
 $ data.city_fias_id : chr [1:2] "c2deb16a-0330-4f05-821f-1d09c93331e6" "c2deb16a-0330-4f05-821f-1d09c93331e6"
 $ data.city         : chr [1:2] "Санкт-Петербург" "Санкт-Петербург"
 $ data.name         : chr [1:2] "Площадь Александра Невского 1" "Площадь Александра Невского 2"
 $ data.line_id      : chr [1:2] "3" "4"
 $ data.line_name    : chr [1:2] "Невско-Василеостровская" "Правобережная"
 $ data.geo_lat      : num [1:2] 59.9 59.9
 $ data.geo_lon      : num [1:2] 30.4 30.4
 $ data.color        : chr [1:2] "009A49" "EA7125"
 $ data.is_closed    : logi [1:2] FALSE FALSE
```

### [Car brand](https://dadata.ru/api/suggest/car_brand/)

``` r
> call <- suggest(method = "car_brand", query = "фо")
> str(call)
tibble [3 × 5] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:3] "Volkswagen" "Ford" "Foton"
 $ unrestricted_value: chr [1:3] "Volkswagen" "Ford" "Foton"
 $ data.id           : chr [1:3] "VOLKSWAGEN" "FORD" "FOTON"
 $ data.name         : chr [1:3] "Volkswagen" "Ford" "Foton"
 $ data.name_ru      : chr [1:3] "Фольксваген" "Форд" "Фотон"
```

### [Currency](https://dadata.ru/api/suggest/currency/)

``` r
> call <- suggest(method = "currency", query = "руб")
> str(call)
tibble [2 × 6] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:2] "Белорусский рубль" "Российский рубль"
 $ unrestricted_value: chr [1:2] "Белорусский рубль" "Российский рубль"
 $ data.code         : chr [1:2] "933" "643"
 $ data.strcode      : chr [1:2] "BYN" "RUB"
 $ data.name         : chr [1:2] "Белорусский рубль" "Российский рубль"
 $ data.country      : chr [1:2] "Беларусь" "Россия"
```

### [OKVED 2](https://dadata.ru/api/suggest/okved2/)

``` r
> call <- suggest(method = "okved2", query = "космических")
> str(call)

tibble [7 × 6] (S3: tbl_df/tbl/data.frame)
 $ value             : chr [1:7] "Производство космических аппаратов (в том числе спутников), ракет-носителей" "Производство частей и принадлежностей летательных и космических аппаратов" "Производство автоматических космических аппаратов" "Производство пилотируемых и беспилотных космических кораблей и станций, включая орбитальные, межпланетные, мног"| __truncated__ ...
 $ unrestricted_value: chr [1:7] "Производство космических аппаратов (в том числе спутников), ракет-носителей" "Производство частей и принадлежностей летательных и космических аппаратов" "Производство автоматических космических аппаратов" "Производство пилотируемых и беспилотных космических кораблей и станций, включая орбитальные, межпланетные, мног"| __truncated__ ...
 $ data.idx          : chr [1:7] "C.30.30.4" "C.30.30.5" "C.30.30.41" "C.30.30.42" ...
 $ data.razdel       : chr [1:7] "C" "C" "C" "C" ...
 $ data.kod          : chr [1:7] "30.30.4" "30.30.5" "30.30.41" "30.30.42" ...
 ...
```

### [OKPD 2](https://dadata.ru/api/suggest/okpd2/)

``` r
> call <- suggest(method = "okpd2", query = "калоши", tidy = FALSE)
> str(call)

List of 1
 $ :List of 3
  ..$ value             : chr "Услуги по обрезинованию валенок (рыбацкие калоши)"
  ..$ unrestricted_value: chr "Услуги по обрезинованию валенок (рыбацкие калоши)"
  ..$ data              :List of 4
  .. ..$ idx   : chr "S.95.23.10.133"
  .. ..$ razdel: chr "S"
  .. ..$ kod   : chr "95.23.10.133"
  .. ..$ name  : chr "Услуги по обрезинованию валенок (рыбацкие калоши)"
```

## Profile API

Balance:

``` r
> personal_info(method = "balance")

$balance
[1] 100
```

Usage stats:

``` r
> personal_info(method = "stat")
$date
[1] "2021-07-21"

$services
$services$clean
[1] 9

$services$suggestions
[1] 58

$services$merging
[1] 0
```

Dataset versions:

``` r
personal_info(method = "version")
$dadata
$dadata$version
[1] "stable (9726:0ed9f754bb40)"


$factor
$factor$version
[1] "21.6.72742 (02f5b13b)"

$factor$resources
$factor$resources$`Перенесённые номера`
[1] "20.07.2021"

$factor$resources$ФИАС
[1] "13.07.2021"

$factor$resources$Геокоординаты
[1] "02.07.2021"

$factor$resources$`Площади квартир`
[1] "25.04.2020"

$factor$resources$`Недейств. паспорта`
[1] "20.07.2021"

$factor$resources$`Цены квартир`
[1] "04.12.2020"
...
```

## Disclaimer

-   This package is in no way affiliated to the DaData.ru company, the
    creator and maintainer of the DADATA REST API.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Make sure to add or update tests as appropriate.
