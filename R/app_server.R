#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd


get_strength_toughness_prob <- function(ST, TO){
  prob = 0
  if(2*ST <= TO){
    prob=6
  }else if (ST < TO){
    prob=5
  }else if (ST == TO){
    prob=4
  }else if (ST >= 2*TO){
    prob=2
  }else if (ST > TO){
    prob=3
  }
  return(prob)
}

get_binom_prob <- function(hit,strength,toughness,armor){

  prob = 1-(hit-1)/6
  prob = prob * (1-((get_strength_toughness_prob(strength,toughness)-1)/6))
  prob = prob * ((armor-1)/6)
  return(prob)
}


app_server <- function(input, output, session) {
  # Your application server logic
}
