

get_dadata_tokens <- function(){
  info <- Sys.getenv("RDADATA",NA)
  if(!is.na(info)){
    mt <- matrix( strsplit(info, split = ";")[[1]], nrow = 2)
    info <- data.frame(t(mt[2,]), stringsAsFactors = FALSE)
    colnames(info) <- mt[1,]
  }else{
    info <- NULL
  }
  return(info)
}




save_dadata_tokens <- function(api_token = NULL,
                               secret_token = NULL){
  # TODO set verbose

  if(is.null(c(api_token, secret_token))){
    stop(call. = FALSE,
         "All tokens must be specified to save credentials to be able to authenticate.")
  }
  env_name <- sprintf("API_TOKEN;%s", api_token)
  env_name <- paste0(env_name, ";", sprintf("SECRET_TOKEN;%s", secret_token))

  Sys.setenv("RDADATA" = env_name)

}

get_organisation <- function(query,
                             kpp = NULL,
                             branch_type = NULL,
                             type = NULL,
                             count = 300, tidy = TRUE, ...){

  query <- as.character(query)
  api_token <- get_dadata_tokens()[,"API_TOKEN"]

  if(is.null(api_token)){
    stop(call. = FALSE, "Please set api_token in save_dadata_tokens()")
  }


  # Check inputs

  if(!is.null(branch_type)){
    if(!branch_type %in% c("MAIN", "BRANCH")){
      stop(call. = FALSE, "branch_type should be MAIN or BRANCH")
    }
  }

  if(!is.null(type)){
    if(!type %in% c("LEGAL", "INDIVIDUAL")){
      stop(call. = FALSE, "branch_type should be LEGAL or INDIVIDUAL")
    }
  }

  if(grepl("[A-z]|[А-я]", query)){
    stop(call. = FALSE, "query should be INN or OGRN number")
  }

  if(!is.numeric(count)){
    stop(call. = FALSE, "count should be numeric")
  }

  if(count > 300){
    stop(call. = FALSE, "maximum inrow count it's 300")
  }

  if(!is.logical(tidy)){
    stop(call. = FALSE, "tidy should be TRUE or FALSE")
  }

  # Request to server
  organisation_list <- list()
  response <- try(httr::POST(
    url = "https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/party",
    httr::content_type_json(),
    httr::accept_json(),
    httr::user_agent("github.com/3davinci"),
    httr::add_headers(Authorization = paste0("Token ", api_token)),
    body = list(query = query,
                count = count,
                kpp = kpp,
                branch_type = branch_type,
                type = type),
    encode = "json"),
    silent = TRUE)

  if(class(response)  == "try-error"){
    stop(call. = FALSE, "Can't request server. Check your internet connection")
  }

  raw_content <-  httr::content(response)

  if(tidy){
    tmp_table <- tibble::tibble()
    for (i in seq(length(raw_content$suggestions))) {
      tmp_table <- tmp_table %>%
        dplyr::bind_rows(tidyjson::spread_all(raw_content$suggestions[i]))
    }

    # convert all dates from numeric do date time
    tmp_table[names(tmp_table) %>% stringr::str_detect("date")]  <- tmp_table[names(tmp_table) %>% stringr::str_detect("date")] %>% dplyr::mutate_all(~as.Date(as.POSIXct(./1000, origin = "1970-01-01")))

    output_table <- tmp_table %>%
      dplyr::select(-document.id, -..JSON)

  } else {
    output_table <- raw_content$suggestions
  }

  return(output_table)
}
