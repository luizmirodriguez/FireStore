#' @title The OAuth function to get access to the cloud firestore:
#' @author Luis Rodriguez
#' @description fireStore::fireStore.google_firestore retrieves a token with read access to the cloud firestore
#' @param client_id The Client ID of your Google OAuth. {string}
#' @param client_secret The Client Secret of your Google OAuth. {string}
#' @param cache Cache the tokens in the .httr-oauth file or not. {boolean}
#' @return Returns the token.
#' @export
#' @examples
#' \dontrun{
#' fireStore.google_firestore("xxxxxxxxxxxxx","xxxxxxxxxxxxxxxxx")
#' }
fireStore.google_firestore <- function(client_id , client_secret , cache = FALSE) {

  response <- httr::oauth_app("google",
                           key = client_id,
                           secret = client_secret)

  httr::oauth2.0_token(httr::oauth_endpoints("google"), response,
                       scope = "https://www.googleapis.com/auth/datastore https://www.googleapis.com/auth/cloud-platform",
                       cache = cache)
}

#' @title Download allows us to download a whole collection of Cloud Firestore
#' @author Luis Rodriguez
#' @description fireStore::fireStore.download a dataframe returns with all the data of the collection
#' @param project_id This is the unique identifier of your Firebase project {string}
#' @param fileName Name of the collection {string}
#' @param token token that returns us the funcion FireStore.google_firestore {string}
#' @param save_path path to save to hard drive in RDS format {string}
#' @return a dataframe returns with all the information of the collection
#' @importFrom httr add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom tractor.base implode
#' @export
#' @examples
#' \dontrun{
#' fireStore.download("mi-proyecto-6465" , "micoleccion", "KxwWNTVdplXFRZwGMkH")
#' }
fireStore.download <- function(project_id,fileName,token, save_path=NULL){
  nextPageToken <-''
  result_save <- c()
  while (TRUE) {
    download_url <- paste0("https://firestore.googleapis.com/v1/projects/",project_id,"/databases/(default)/documents/",fileName,"?pageSize=300",nextPageToken)
    message(paste0("download...",download_url))
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

#' @title Count allows us to count records from a Cloud Firestore collection
#' @author Luis Rodriguez
#' @description fireStore::fireStore.count returns a number of the number of records
#' @param project_id This is the unique identifier of your Firebase project {string}
#' @param fileName Name of the collection {string}
#' @param token token that returns the function FireStore.google_firestore{string}
#' @return returns a number of the number of records
#' @importFrom httr add_headers
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' \dontrun{
#' fireStore.count("mi-proyecto-6465" , "micoleccion", "KxwWNTVdplXFRZwGMkH")
#' }
fireStore.count <- function(project_id,fileName,token){
  pagination <- 300
  nextPageToken <-''
  i <- 0
  while (TRUE) {
    count_url  <- paste0("https://firestore.googleapis.com/v1/projects/",project_id,"/databases/(default)/documents/",fileName,"?pageSize=",pagination,nextPageToken)
    message(paste0("count...",count_url ))
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


