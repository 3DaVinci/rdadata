

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

usethis::use_git()
