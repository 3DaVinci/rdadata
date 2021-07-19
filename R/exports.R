#' @title Retrieves the previously saved API tokens
#' @description Retrieves a \code{data.frame} with the available tokens
#' previously saved into the environment under the RDADATA variable
#' through the \code{save_dadata_tokens()} function.
#' @return Returns a \code{data.frame} with the saved API tokens
#' @examples
#' \dontrun{
#' save_dadata_tokens(api_token='__INSERT_YOUR_API_TOKEN_HERE__',
#'                    secret_token='__INSERT_YOUR_SECRET_TOKEN_HERE__')
#' get_dadata_tokens()
#' }
#' @export

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


#' @title Saves credentials tokens in the environment
#' @description Saves credentials tokens
#' the users' environment. It has the advantage that it is not necessary
#' to explicitly publish the credentials in the users code. Just do it one
#' time and you are set. To update any of the parameters just save again and
#' it will overwrite the older credential.
#' @param api_token Token required for REST API authorization.
#' You can get the token on your personal profile page,
#' after logging in at \href{https://dadata.ru/profile/#info}{https://dadata.ru/profile/#info}.
#' It will be saved in the environment as API_TOKEN.
#' @param secret_token Token required for paid plans.
#' It will be saved in the environment as SECRET_TOKEN.
#' @return Saves the tokens in the users environment - it does not return any object.
#' @examples
#' \dontrun{
#' save_dadata_tokens(api_token='__INSERT_YOUR_API_TOKEN_HERE__',
#'                    secret_token='__INSERT_YOUR_SECRET_TOKEN_HERE__')
#' }
#' @export

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
