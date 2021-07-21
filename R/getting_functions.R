#' @title Returns the supported API names for suggestions methods
#' @description Function shows all  supported API names that are
#' available to choose for the \code{suggest()} function.
#' @return Returns a character vector of all supported API names.
#' @export
supported_suggestions <- function(){
  return(
    c(
      "address",
      "postal_unit",
      "country",
      "party",
      "bank",
      "fio",
      "fms_unit",
      "email",
      "fns_unit",
      "fts_unit",
      "region_court",
      "metro",
      "car_brand",
      "mktu",
      "okved2",
      "okpd2",
      "oktmo",
      "currency",
      "find_affiliated")
    )
}

#' @title Returns the supported API names for find by ID methods
#' @description Function shows all supported API names that are
#' available to choose for the \code{find_by_id()} function.
#' @return Returns a character vector of all supported API names.
#' @export
supported_find_by_id <- function(){
  return(
    c(
      "postal_unit",
      "country",
      "fns_unit",
      "fts_unit",
      "region_court",
      "car_brand",
      "mktu",
      "okved2",
      "party",
      "okpd2",
      "oktmo",
      "currency",
      "address",
      "delivery",
      "fias",
      "bank",
      "cadastre")
    )
}

#' @title Returns the supported API names for cleans methods
#' @description Function shows all  supported API names that are
#' available to choose for the \code{clean()} function.
#' @return Returns a character vector of all supported API names.
#' @export
supported_cleans <- function(){
  return(
    c("address",
      "geocode",
      "name",
      "phone",
      "passport",
      "email",
      "clean"))
}

#' @title Methods, grouped by type of request calling «suggest».
#' @description Calls DADATA's REST API, with one of the available methods. All supported
#' methods related with «suggestion» you can see in \code{supported_suggestion()}
#' @param method Name of supported method. Use \code{supported_suggestion()} to see all supported methods.
#' @param query Main request. See examples or \href{https://dadata.ru/api/}{https://dadata.ru/api/} for more.
#' @param tidy If TRUE returns response from the server as tidy \code{tibble}. Else, returns JSON as nested list.
#' @param ... Specify additional calling parameters, if necessary. For more information on available parameters of
#' corresponding method, see the description page on \href{https://dadata.ru/api/}{https://dadata.ru/api/}
#' @seealso For more information about DADATA API visit the following link:
#' \href{https://dadata.ru/api/}{DADATA API Documentation}.
#' @examples
#' #save your tokens first
#' \dontrun{
#' save_dadata_tokens(api_token='__INSERT_YOUR_API_TOKEN_HERE__',
#'                    secret_token='__INSERT_YOUR_SECRET_TOKEN_HERE__')
#' }
#' #Suggest country
#' suggest(method = "country", query = "та")
#'
#' #Suggest company with spicified parametrs
#' suggest(method = "party", query = "сбер", branch_type = "MAIN", count = 20)
#'
#' #Suggest bank
#' suggest(method = "bank", query = "ти")
#' @export

suggest <- function(method,
                    query = NULL,
                    tidy = TRUE, ...) {

  if (!method %in% supported_suggestions()) {
    stop(call. = FALSE, "Incorrect API method. Check valid supported_suggestions")
  }

  query <- as.character(query)

  if (method == "find_affiliated") {
    api_url <- "https://suggestions.dadata.ru/suggestions/api/4_1/rs/findAffiliated/party"
  } else {
    api_url <- paste0("https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/", method)
  }

  api_token <- get_dadata_tokens()[,"API_TOKEN"]

  if (is.null(api_token)) {
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }

  if (!is.logical(tidy)) {
    stop(call. = FALSE, "tidy should be TRUE or FALSE")
  }

  response <- try(httr::POST(
    url = api_url,
    httr::content_type_json(),
    httr::accept_json(),
    httr::user_agent("github.com/3davinci/rdadata"),
    httr::add_headers(Authorization = paste0("Token ", api_token)),
    body = list(query = query,
                ...),
    encode = "json"),
    silent = TRUE)

  if(class(response)  == "try-error"){
    stop(call. = FALSE, "Can't request server. Check your internet connection or validate query")
  }

  if(response$status_code != 200){
    stop(call. = FALSE, paste0("Server error, code ", response$status_code,
                               ". Check your tokens or validate query"))
  }

  raw_content <-  httr::content(response)

  if(length(raw_content$suggestions) == 0){
    stop(call. = FALSE, "Empty response from server. Validate your query or try to use find_by_id() instead.")
  }

  if(tidy){
    tmp_table <- data.frame()
    for (i in seq(length(raw_content$suggestions))) {
      tmp_table <- tmp_table %>%
        dplyr::bind_rows(tidyjson::spread_all(raw_content$suggestions[i]))
    }

    # convert all dates from numeric do date time
    tmp_table[grepl("date", names(tmp_table))]  <- tmp_table[grepl("date", names(tmp_table))] %>% dplyr::mutate_all(~as.Date(as.POSIXct(./1000, origin = "1970-01-01")))

    output_table <- tmp_table %>%
      dplyr::as_tibble() %>%
      dplyr::select(-document.id, -..JSON)
  } else {
    output_table <- raw_content$suggestions
  }

  return(output_table)
}

#' @title Methods, grouped by type of request calling «findById».
#' @description Calls DADATA's REST API, with one of the available methods. All supported
#' methods related with «suggestion» you can see in \code{supported_find_by_id()}
#' @param method Name of supported method. Use \code{supported_find_by_id()} to see all supported methods.
#' @param query Main request. See examples or \href{https://dadata.ru/api/}{https://dadata.ru/api/} for more.
#' @param tidy If TRUE returns response from the server as tidy \code{tibble}. Else, returns JSON as nested list.
#' @param ... Specify additional calling parameters, if necessary. For more information on available parameters of
#' corresponding method, see the description page on \href{https://dadata.ru/api/}{https://dadata.ru/api/}
#' @seealso For more information about DADATA API visit the following link:
#' \href{https://dadata.ru/api/}{DADATA API Documentation}.
#' @examples
#' #save your tokens first
#' \dontrun{
#' save_dadata_tokens(api_token = '__INSERT_YOUR_API_TOKEN_HERE__',
#'                    secret_token = '__INSERT_YOUR_SECRET_TOKEN_HERE__')
#' }
#' #Find address by FIAS ID
#' find_by_id(method = "address", query = "9120b43f-2fae-4838-a144-85e43c2bfb29")
#'
#' #Find company by INN and KPP:
#' find_by_id(method = "party", query = "7707083893", kpp = "540602001")
#'
#' #Tax office
#' find_by_id(method = "fns_unit", query = "5257")
#' @export
find_by_id <- function(method,
                    query = NULL,
                    tidy = TRUE, ...) {

  if(!method %in% supported_find_by_id()){
    stop(call. = FALSE, "Incorrect API method. Check valid supported_find_by_id")
  }

  query <- as.character(query)
  api_url <- paste0("https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/", method)
  api_token <- get_dadata_tokens()[,"API_TOKEN"]
  secret_token <- get_dadata_tokens()[,"SECRET_TOKEN"]

  if(method != "cadastre"){
    secret_token <- NULL
  }

  if(is.null(api_token)){
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }


  if(!is.logical(tidy)){
    stop(call. = FALSE, "tidy should be TRUE or FALSE")
  }

  response <- try(httr::POST(
    url = api_url,
    httr::content_type_json(),
    httr::accept_json(),
    httr::user_agent("github.com/3davinci/rdadata"),
    httr::add_headers(Authorization = paste0("Token ", api_token),
                      `X-Secret` = secret_token),
    body = list(query = query,
                ...),
    encode = "json"),
    silent = TRUE)

  if(class(response)  == "try-error"){
    stop(call. = FALSE, "Can't request server. Check your internet connection or validate query")
  }

  if(response$status_code != 200){
    stop(call. = FALSE, paste0("Server error, code ", response$status_code,
                               ". Check your tokens or validate query"))
  }

  raw_content <-  httr::content(response)

  if(length(raw_content$suggestions) == 0){
    stop(call. = FALSE, "Empty response from server. Validate your query or try to use suggest() instead.")
  }

  if(tidy){
    tmp_table <- data.frame()
    for (i in seq(length(raw_content$suggestions))) {
      tmp_table <- tmp_table %>%
        dplyr::bind_rows(tidyjson::spread_all(raw_content$suggestions[i]))
    }

    # convert all dates from numeric do date time
    tmp_table[grepl("date", names(tmp_table))]  <- tmp_table[grepl("date", names(tmp_table))] %>% dplyr::mutate_all(~as.Date(as.POSIXct(./1000, origin = "1970-01-01")))

    output_table <- tmp_table %>%
      dplyr::as_tibble() %>%
      dplyr::select(-document.id, -..JSON)
  } else {
    output_table <- raw_content$suggestions
  }

  return(output_table)
}

#' @title Methods, grouped by type of request calling «clean».
#' @description Calls DADATA's REST API, with one of the available methods. All supported
#' methods related with «suggestion» you can see in \code{supported_cleans()}
#' @param method Name of supported method. Use \code{supported_cleans()} to see all supported methods.
#' @param query Main request. See examples or \href{https://dadata.ru/api/}{https://dadata.ru/api/} for more.
#' @param tidy If TRUE returns response from the server as tidy \code{tibble}. Else, returns JSON as nested list.
#' @param ... Specify additional calling parameters, if necessary. For more information on available parameters of
#' corresponding method, see the description page on \href{https://dadata.ru/api/}{https://dadata.ru/api/}
#' @seealso For more information about DADATA API visit the following link:
#' \href{https://dadata.ru/api/}{DADATA API Documentation}.
#' @section Warning:
#' All methods presented in this section are for a fee. Learn more about costs on \href{https://dadata.ru/api/}{DADATA API Documentation}
#' @examples
#' #save your tokens first
#' \dontrun{
#' save_dadata_tokens(api_token = '__INSERT_YOUR_API_TOKEN_HERE__',
#'                    secret_token = '__INSERT_YOUR_SECRET_TOKEN_HERE__')
#' }
#' # Validate and cleanse address
#' clean(method = "address", "мск сухонска 11/-89")
#' # Validate and cleanse name
#' clean(method = "name", query = "Срегей владимерович иванов")
#' # Validate and cleanse phone
#' clean(method = "phone", "раб 846)231.60.14 *139")
#' @export
clean <- function(method,
                  query,
                  tidy = TRUE, ...){

  query <- as.character(query)
  api_token <- get_dadata_tokens()[,"API_TOKEN"]
  secret_token <- get_dadata_tokens()[,"SECRET_TOKEN"]

  if(is.null(api_token)){
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }

  if(is.null(secret_token)){
    stop(call. = FALSE, "Please set secret_token in save_dadata_tokens()")
  }

  if(!is.logical(tidy)){
    stop(call. = FALSE, "tidy should be TRUE or FALSE")
  }

  if(!method %in% supported_cleans()){
    stop(call. = FALSE, "Incorrect API method. Check valid supported_cleans")
  }

  if(method == "geocode"){method <- "address"}

  if(method == "clean"){
    url <- "https://cleaner.dadata.ru/api/v1/clean/"
  } else {
    url <- paste0("https://cleaner.dadata.ru/api/v1/clean/", method)
  }

  response <- try(httr::POST(
    url = url,
    httr::content_type_json(),
    httr::user_agent("github.com/3davinci/rdadata"),
    httr::add_headers(Authorization = paste0("Token ", api_token),
                      `X-Secret` = secret_token),
    body = list(query, ...),
    encode ="json"),
    silent = TRUE)

  if(class(response)  == "try-error"){
    stop(call. = FALSE, "Can't request server. Check your internet connection or validate query")
  }

  if(response$status_code != 200){
    stop(call. = FALSE, paste0("Server error, code ", response$status_code,
                               ". Check your tokens, balance or validate query"))
  }

  raw_content <-  httr::content(response)

  if(tidy){
    tmp_table <- data.frame()
    for (i in seq(length(raw_content))) {
      tmp_table <- tmp_table %>%
        dplyr::bind_rows(tidyjson::spread_all(raw_content[i]))
    }

    # convert all dates from numeric do date time
    tmp_table[grepl("date", names(tmp_table))]  <- tmp_table[grepl("date", names(tmp_table))] %>% dplyr::mutate_all(~as.Date(as.POSIXct(./1000, origin = "1970-01-01")))

    output_table <- tmp_table %>%
      dplyr::as_tibble() %>%
      dplyr::select(-document.id, -..JSON)
  } else {
    output_table <- raw_content
  }

  return(output_table)
}

#' @title Methods, that shown your personal info
#' @description Calls available methods to check your personal info on DADATA
#' @param method Name of supported method. Available 3 methods, without adjusted parameters:
#' \itemize{
#' \item stat
#' \item balance
#' \item version
#' }
#' @examples
#' # show your stats of used methods
#' personal_info("stat")
#' # show your current balance
#' personal_info("balance")
#' # show actual time of available resources
#' personal_info("version")
#' @export
personal_info <- function(method) {

  if(!method %in% c("stat", "balance", "version")){
    stop(call. = FALSE, "method should be one of them: stat, balance, version")
  }

  api_token <- get_dadata_tokens()[,"API_TOKEN"]
  secret_token <- get_dadata_tokens()[,"SECRET_TOKEN"]

  if(is.null(api_token)){
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }

  if(is.null(secret_token)){
    stop(call. = FALSE, "Please set secret_token in save_dadata_tokens()")
  }

  if(method == "version"){
    secret_token <- NULL
    url <- "https://dadata.ru/api/v2/version"
  } else if(method == "stat") {
    url <- "https://dadata.ru/api/v2/stat/daily"
  } else {
    url <- "https://dadata.ru/api/v2/profile/balance"
  }

  response <- try(httr::GET(
    url = url,
    httr::user_agent("github.com/3davinci/rdadata"),
    httr::add_headers(Authorization = paste0("Token ", api_token),
                      `X-Secret` = secret_token),
    encode ="json"),
    silent = TRUE)

  if(class(response)  == "try-error"){
    stop(call. = FALSE, "Can't request server. Check your internet connection.")
  }

  if(response$status_code != 200){
    stop(call. = FALSE, paste0("Server error, code ", response$status_code,
                               ". Check your tokens"))
  }

  raw_content <-  httr::content(response)
  return(raw_content)
}

#' @title Methods, grouped by type of request calling «locate» --- «geo» and «ip»
#' @description Calls DADATA's REST API, with one of the available methods.
#' @param method Name of supported method. Only «ip» or «geo»
#' @param tidy If TRUE returns response from the server as tidy \code{tibble}. Else, returns JSON as nested list.
#' @param ... Specify additional calling parameters. For more information on available parameters of
#' corresponding method, see the description page on \href{https://dadata.ru/api/}{https://dadata.ru/api/}
#' @seealso For more information about DADATA API visit the following link:
#' \href{https://dadata.ru/api/}{DADATA API Documentation}.
#' @examples
#' #save your tokens first
#' \dontrun{
#' save_dadata_tokens(api_token = '__INSERT_YOUR_API_TOKEN_HERE__',
#'                    secret_token = '__INSERT_YOUR_SECRET_TOKEN_HERE__')
#' }
#' # Identifies the city by its IP address in Russia. Uses the client's IP address
#' locate(method = "ip", ip = "46.226.227.20")
#' # request with a radius limit of 50 m
#' locate(method = "geo", lat = 55.601983, lon = 37.359486, radius_meters = 50)
#' @export
locate <- function(method, tidy = TRUE, ...) {

  if(!method %in% c("ip", "geo")){
    stop(call. = FALSE, "method should be «ip» or «geo»")
  }

  api_token <- get_dadata_tokens()[,"API_TOKEN"]
  secret_token <- get_dadata_tokens()[,"SECRET_TOKEN"]

  if(is.null(api_token)){
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }

  if(is.null(secret_token)){
    stop(call. = FALSE, "Please set secret_token in save_dadata_tokens()")
  }

  domain <- paste0("https://suggestions.dadata.ru/suggestions/api/4_1/rs/",
                   method, "locate/address")

  url <- httr::modify_url(
    url = domain,
    query = list(...))

  response <- httr::GET(
    url,
    httr::user_agent("github.com/3davinci/rdadata"),
    httr::accept_json(),
    httr::add_headers(Authorization = paste0("Token ", api_token),
                      `X-Secret` = secret_token),
    encode ="json"
  )

  if(class(response)  == "try-error"){
    stop(call. = FALSE, "Can't request server. Check your internet connection or validate query")
  }

  if(response$status_code != 200){
    stop(call. = FALSE, paste0("Server error, code ", response$status_code,
                               ". Check your tokens or validate query"))
  }

  raw_content <- httr::content(response)

  if(method == "ip"){
    iterate_list <- raw_content
  } else {
    iterate_list <- raw_content$suggestions}

  if(tidy){
    tmp_table <- data.frame()
    for (i in seq(length(iterate_list))) {
      tmp_table <- tmp_table %>%
        dplyr::bind_rows(tidyjson::spread_all(iterate_list[i]))
    }

    output_table <- tmp_table %>%
      dplyr::as_tibble() %>%
      dplyr::select(-document.id, -..JSON)
  } else {
    output_table <- iterate_list
  }

  return(output_table)
}

