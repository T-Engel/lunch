#' @import rvest
#' @import praise
#' @import R.utils
#'
NULL


#' Check MPI menu
#'
#' @return
#' @export
#'
#' @examples
whatsforlunch<- function(){
    #Doing some research
    day= as.POSIXlt(Sys.Date())$wday
    week= get_menu()
    today= todays_menu(week, day)
    todays_alerts= check_alert(today, alerts=alerts)
    upcoming<-sapply((day+1):5, function(x) check_alert(todays_menu(week,x), alerts= alerts))
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

#' Makes a message about alerts taking into account whe
#'
#' @return

make_alert_message<-function(todays_alerts, upcoming){

    if(is.null(todays_alerts)| length(todays_alerts)==0){
        todays_message =sample(today_alert_chunks[[2]],1)

    }else{
        todays_message = paste0(capitalize(sample(praise_parts$exclamation, 1)),
                                ",",
                                " ",
                                sample(today_alert_chunks[[1]],1),
                                " ",
                                todays_alerts
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
                                upcoming,
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


