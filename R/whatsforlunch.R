#' Browsing the MPI menu
#'
#' Opens the MPI website in your browser.
#'
#'
#' @examples \dontrun{
#' whatsforlunch()
#' }
#'
whatsforlunch<- function(){
    link= "http://www.tafelwerk-leipzig.de/index.php?id=11"

    message <- enjoy()

    if (format(Sys.time(),"%H")< 11) {
        message<- "It's before 11 and you are already thinking about lunch?"
    }
    if (format(Sys.time(),"%H")> 13) {
        message<-"You're a little late today. The good options might all be gone by now, but there is alway Asia Imbiss"
    }
    print(message)

    Sys.sleep(5)
    browseURL(link)
}


enjoy <-function() {
    sentences <- c(
        "Enjoy your meal!",
        "You know there's always Asia Imbiss",
        "MPI is like a box of chocolates. You never know what you're gonna get!",
        "The MPI lady will smile at you if you have exact change.",
        "HIT me baby one more time",
        "Why are you even checking? Don't you ALWAYS have the vegetarian option regardles of what it is?"
    )
    out<- sample(sentences,1)
    return(out)
}
