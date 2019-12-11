
#' Download menu text from link
#'
#' @return character.
#'

get_menu<-function(){

    website<- read_html(link)

    text <-html_text(website)
    return(text)
}



#' Check menu for alerts
#'
#' @param menu  character string
#' @param alerts a vector of alerts
#'
#' @return a vector of all the relevant alerts
#'
#'
#' @examples
check_alert<-function(menu, alerts= alerts){
    result<-sapply(alerts, function(term) grepl(term, menu, ignore.case=T))

    return(alerts[result])
}


#' Title
#'
#' @param menu character string
#' @param day numeric weekday
#'
#' @return
#'
#' @examples
todays_menu<-function(menu , day ){
    days <- c("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag")

  out<-  unlist(strsplit(menu, split = days[day]))[2]
  out<-  unlist(strsplit(out, split = days[day+1]))[1]
  return(out)

}


