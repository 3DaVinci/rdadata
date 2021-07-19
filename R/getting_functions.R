#' @title Returns the supported API names for suggestions methods
#' @description Function shows all the supported API names that are
#' available to choose for the \code{suggest()} function.
#' @return Returns a character vector of all the supported API names.
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
      "currency")
    )
}

#' @title Returns the supported API names for find by ID methods
#' @description Function shows all the supported API names that are
#' available to choose for the \code{find_by_id()} function.
#' @return Returns a character vector of all the supported API names.
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
      "bank")
    )
}


suggest <- function(name,
                    query = NULL,
                    count = 10,
                    tidy = TRUE,
                    ...) {

  if(!name %in% supported_suggestions()){
    stop(call. = FALSE, "Incorrect API name. Check valid supported_suggestions")
  }

  query <- as.character(query)
  api_url <- paste0("https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/", name)

  # set tokens
  api_token <- get_dadata_tokens()[,"API_TOKEN"]

  # Checks
  if(is.null(api_token)){
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }

  if(!is.numeric(count)){
    stop(call. = FALSE, "count should be numeric")
  }

  if(!is.logical(tidy)){
    stop(call. = FALSE, "tidy should be TRUE or FALSE")
  }

  response <- try(httr::POST(
    url = api_url,
    httr::content_type_json(),
    httr::accept_json(),
    httr::user_agent("github.com/3davinci"),
    httr::add_headers(Authorization = paste0("Token ", api_token)),
    body = list(query = query,
                count = count,
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


find_by_id <- function(name,
                    query = NULL,
                    tidy = TRUE,
                    ...) {

  if(!name %in% supported_find_by_id()){
    stop(call. = FALSE, "Incorrect API name. Check valid supported_find_by_id")
  }

  query <- as.character(query)
  api_url <- paste0("https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/", name)

  # set tokens
  api_token <- get_dadata_tokens()[,"API_TOKEN"]

  # Checks
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
    httr::user_agent("github.com/3davinci"),
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

