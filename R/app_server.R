#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd


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
  output$kill_dens <- renderPlot({
    # generate bins based on input$bins from ui.R
    # generate bins based on input$bins from ui.R
    hits <- input$NumberHits
    prob_hit <- get_prob_hit(input$WS)
    prob_wound <- get_prob_wound(input$Strength,input$TargetToughness)
    prob_go_through_save <- get_prob_save(input$TargetSave)
    #Combine all prob using get_prob_save
    prob_binom <- get_binom_prob(prob_hit,prob_wound,prob_go_through_save)
    # draw the histogram with the specified number of bins
    nb_kills <- get_kill_count(hits, input$Damage, input$TargetLifePoints)
    plot(seq(1,nb_kills),dbinom(seq(1,nb_kills),nb_kills,prob=prob_binom),type='h')

  })
}
