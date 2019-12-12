#' @import rvest
#' @import praise
#' @import utils
#' @import xml2
requireNamespace("rvest")
requireNamespace("praise")
requireNamespace("xml2")
requireNamespace("R.utils")


#' Check MPI menu
#'
#'
#' @export
#' @importFrom utils askYesNo browseURL
#' @importFrom R.utils capitalize
#'

whatsforlunch<- function(){
    #Doing some research
    day= as.POSIXlt(Sys.Date())$wday
    week= get_menu()
    today= todays_menu(week, day)

    all_alerts= union(alerts, get_my_lunch_alerts())
    todays_alerts= check_alert(today, alerts=all_alerts)
    upcoming<-sapply((day+1):5, function(x) check_alert(todays_menu(week,x), alerts= all_alerts))
    if(day>=5) upcoming = NULL
    upcoming<- unlist(upcoming)

    #Greeting
    greeting=make_greeting()

    # Time /Day
    time_message = make_time_message()

    # alerts

    alert_message = make_alert_message(todays_alerts = todays_alerts,upcoming = upcoming)

    if(day>5){
        combined_message = paste0(
            greeting,
            " \n",
            time_message

        )
        cat(combined_message)
    }else{
        combined_message = paste0(
            greeting,
            " \n",
            time_message,
            " \n",
            alert_message,
            "\n \n",
            sample(question_chunks,1)

        )

        if (interactive()) if(askYesNo(msg =combined_message )) browseURL(link)

    }

}

#' Makes a greeting including an adjective and the day of the week
#'
#' @return character.

make_greeting<- function(){
    day <- as.POSIXlt(Sys.Date())$wday

    adjective <- capitalize( sample(praise_parts$adjective,1))
    day_name <- c( "Monday", "Tuesday", "Wednesday", "Thursday",
                   "Friday", "Saturday", "Sunday")[day]

    greeting <- paste0(adjective," ", day_name,"!")
    return(greeting)


}

#' Makes a message commenting on the time or day
#'
#' @return character.

make_time_message<- function(){
    message <- sample(timely_chunks,1)
    if (format(Sys.time(),"%H")< 10) {
        message<- sample(early_chunks, 1)
    }
    if (format(Sys.time(),"%H")>= 14) {
        message <- sample(late_chunks, 1)
    }
    if (format(Sys.time(),"%H")>= 15) {
        message <- character()
    }
    if (as.POSIXlt(Sys.Date())$wday > 5 ){
        message <- sample(weekend_chunks, 1)
    }
    return(message)

}

make_numeration= function(text){
    len=length(text)
    if(len==1){
        out= text
        }else{
        out= paste(paste(text[-len],collapse = ", "), text[len], sep = " and ")
    }
    return(out)
    }

#' Makes a message about alerts taking into account whe
#'
#' @param todays_alerts character vector
#' @param upcoming character vector
#'
#' @return character.

make_alert_message<-function(todays_alerts, upcoming){

    if(is.null(todays_alerts)| length(todays_alerts)==0){
        todays_message =sample(today_alert_chunks[[2]],1)

    }else{
        todays_message = paste0(capitalize(sample(praise_parts$exclamation, 1)),
                                ",",
                                " ",
                                sample(today_alert_chunks[[1]],1),
                                " ",
                                make_numeration(todays_alerts)
        )

    }

    if(is.null(upcoming)| length(upcoming)==0){
        upcoming_message =paste0(" ",sample(upcoming_alert_chunks[[2]],1))

    }else{
        upcoming_message = paste0(
                                ", ",
                                sample(praise_parts$exclamation, 1),
                                ", ",
                                sample(upcoming_alert_chunks[[1]],1),
                                " ",
                                make_numeration(upcoming),
                                "."
        )

    }


    conjunction<-ifelse({is.null(todays_alerts)|length(todays_alerts)==0 }& {!is.null(upcoming)| length(upcoming)!=0}, "but", "and")
    if  (format(Sys.time(),"%H")>= 15){
        todays_message= sample(closed_chunks, 1)
        conjunction<-ifelse({is.null(upcoming)|length(upcoming)==0 },  "and", "but")
    }
    total = paste0(todays_message," ", conjunction, upcoming_message)
    return(total)
}

#' See user-defined lunch alerts
#'
#' @param escape unescape unicode character sequences?
#'
#' @return character vector
#'
#' @importFrom stringi stri_unescape_unicode
#' @export

get_my_lunch_alerts<-function(escape=T){
    my_lunch_alerts=Sys.getenv("my_lunch_alerts")
    my_lunch_alerts= gsub(" ", "", my_lunch_alerts, fixed = TRUE)
    if(escape==T) my_lunch_alerts= stringi::stri_unescape_unicode(my_lunch_alerts)
    my_lunch_alerts= unlist(strsplit(my_lunch_alerts, ","))


    return(my_lunch_alerts)
}

#' Customize lunch alerts
#'
#' Creates a character string, copies it to the clipboard and opens the .Renviron file.
#' Then the user pastes the string and saves the file.
#'
#' @param alerts character vector of food alerts.
#' @param append add to previously set alerts?
#' @importFrom stringi stri_escape_unicode
#' @importFrom usethis edit_r_environ
#'
#' @export
#'
set_my_lunch_alerts<- function(alerts, append =T){
    alerts= stringi::stri_escape_unicode(alerts)
    if(append){
    old_alerts=get_my_lunch_alerts(escape = F)
    alerts= paste0(union(old_alerts, alerts), collapse = ",")
    }
    alert_string= paste0("my_lunch_alerts=","\"",alerts, "\"")
    writeClipboard(alert_string)

    message= "Your lunch alerts have been copied to the clipboard. Please, paste them into your .Renviron file. This will help me remember them the next time you load the package. Then save the file and restart R. \n \n Do you want me to open the .Renviron file now?"

    if (interactive()) if(askYesNo(msg =message )) edit_r_environ()

}
