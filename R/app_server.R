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
  ##Lets get the probability to get a damage through

  output$probDens <- renderPlot({
    # generate bins based on input$bins from ui.R
    hits <- input$NumberHits
    prob_hit <- get_prob_hit(input$WS)
    prob_wound <- get_prob_wound(input$Strength,input$TargetToughness)
    prob_go_through_save <- get_prob_save(input$TargetSave)
    #Combine all prob using get_prob_save
    prob_binom <- get_binom_prob(prob_hit,prob_wound,prob_go_through_save)
    # draw the histogram with the specified number of bins
    plot(seq(1,hits),dbinom(seq(1,hits),hits,prob=prob_binom),type='h')

  })
  output$probDens_old <- renderPlot({
    # generate bins based on input$bins from ui.R
    hits <- input$NumberHits
    ##Hit modifyer
    if(input$noArmor){
      armor = 7
    }else{
      armor = input$TargetSave
    }
    pp = get_binom_prob_old(input$WS,input$Strength,input$TargetToughness,armor)
    # draw the histogram with the specified number of bins
    plot(seq(1,hits),dbinom(seq(1,hits),hits,prob=pp),type='h')

  })
}
