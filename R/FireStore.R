#' @title The OAuth function to get access to the cloud firestore:
#' @author Paul Spende
#' @description fireStore::fireStore.google_firestore retrieves a token with read access to the cloud firestore
#' @param web_client_id The Web Client ID of your Google OAuth in your Firebase. {string}
#' @param web_client_secret The Web Client Secret of your Google OAuth in your Firebase. {string}
#' @param cache Cache the tokens in the .httr-oauth file or not. {boolean}
#' @return Returns the token data.
#' @export
#' @examples
#' fireStore.google_firestore("xxxxxxxxxxxxx","xxxxxxxxxxxxxxxxx")
fireStore.google_firestore <- function(web_client_id = "prompt", web_client_secret = "prompt", cache = FALSE) {
  if (web_client_id == "prompt" && web_client_secret == "prompt") {
    web_client_id <- readline(prompt = "Web Client ID: ")
    web_client_secret <- readline(prompt = "Web Client Secret: ")
  }

  myapp <- httr::oauth_app("google",
                           key = web_client_id,
                           secret = web_client_secret)

  httr::oauth2.0_token(httr::oauth_endpoints("google"), myapp,
                       scope = "https://www.googleapis.com/auth/datastore https://www.googleapis.com/auth/cloud-platform",
                       cache = cache)
}

#' @title Download nos permite descargar toda una coleccion  de Cloud Firestore
#' @author Luis Rodriguez
#' @description fireStore::fireStore.download nos retorna un dataframe con la toda la data de la coleccion
#' @param project_id Este es el identificador unico de tu proyecto de Firebase. {string}
#' @param fileName nombre de la coleccion. {string}
#' @param token token que nos retorna la funcion FireStore.google_firestore {string}
#' @param save_path ruta para guardar en el disco duro en formato RDS {string}
#' @return retorna un dataframe con el toda la informacion de la coleccion
#' @export
#' @examples
#' fireStore.download("mi-proyecto-6465" , "micoleccion", auth$credentials$access_token ,"D://archivo.rds")
fireStore.download <- function(project_id,fileName,token, save_path=NULL){
  nextPageToken <-''
  result_save <- c()
  while (TRUE) {
    download_url <- paste0("https://firestore.googleapis.com/v1/projects/",project_id,"/databases/(default)/documents/",fileName,"?pageSize=300",nextPageToken)
    print(paste0("download...",download_url))
    response <- httr::GET(url = download_url, add_headers("Authorization" = paste0("Bearer ", token)))
    response <- httr::content(response,"text", encoding = "UTF-8")
    response_tmp <- fromJSON(response)
    result_save <- c(result_save,response)
    if ("nextPageToken" %in% names(response_tmp)){
      nextPageToken <- paste0("&pageToken=",response_tmp$nextPageToken)
    }else{
      json<-paste0("[",implode(result_save,","),"]")
      result <- as.data.frame(fromJSON(json))
      if (!is.null(save_path)){
        saveRDS(result, file= paste0(save_path))
      }
      return(result)
    }
  }
}

#' @title Count nos permite hace un conteo de registros de una coleccion  de Cloud Firestore
#' @author Luis Rodriguez
#' @description fireStore::fireStore.count nos retorna un numero de la cantidad de registros
#' @param project_id Este es el identificador único de tu proyecto de Firebase. {string}
#' @param fileName nombre de la coleccion. {string}
#' @param token token que nos retorna la funcion FireStore.google_firestore {string}
#' @return retorna un numero de la cantidad de registros
#' @export
#' @examples
#' fireStore.count("mi-proyecto-6465" , "micoleccion", auth$credentials$access_token)
fireStore.count <- function(project_id,fileName,token){
  pagination <- 300
  nextPageToken <-''
  i <- 0
  while (TRUE) {
    count_url  <- paste0("https://firestore.googleapis.com/v1/projects/",project_id,"/databases/(default)/documents/",fileName,"?pageSize=",pagination,nextPageToken)
    print(paste0("count...",count_url ))
    response <- httr::GET(url = count_url , add_headers("Authorization" = paste0("Bearer ", token)))
    response <- httr::content(response,"text", encoding = "UTF-8")
    response_tmp <- fromJSON(response)
    if ("nextPageToken" %in% names(response_tmp)){
      nextPageToken <- paste0("&pageToken=",response_tmp$nextPageToken)
      i <- i+1
    }else{
      result <- as.data.frame(response_tmp)
      if (i==0){
        return(nrow(result))
      }else{
        return ((i*pagination)+nrow(result))
      }
    }
  }
}


