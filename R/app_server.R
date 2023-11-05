#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd


app_server <- function(input, output, session) {
  ##Lets get the probability to get a damage through
  binom_prob <- reactive({
    hits <- input$NumberHits
    prob_hit <- get_prob_hit(input$WS)
    prob_wound <- get_prob_wound(input$Strength,input$TargetToughness)
    prob_go_through_save <- get_prob_save(input$TargetSave)

    #Get the initial number of damage using the damage characteristic of the weapon
    nb_wounds <- get_wound_count(hits,input$Damage)

    #Combine all prob using get_prob_save
    prob_binom <- get_binom_prob(prob_hit,prob_wound,prob_go_through_save)

    # Get the prob to damage a model
    return(prob_binom)
  })

  output$probDens <- renderPlot({
    #Get the initial number of damage using the damage characteristic of the weapon
    nb_wounds <- get_wound_count(input$NumberHits,input$Damage)

    #Get the binomial probability associated with wounds
    binom_damage = dbinom(seq(0,nb_wounds),nb_wounds,prob=binom_prob())

    # draw the histogram with the specified number of bins
    damage_barplot <- barplot(binom_damage,names.arg = seq(0,get_wound_count(input$NumberHits,input$Damage)),col="#69b3a2",ylim = c(0,max(binom_damage)+0.05))
    text(damage_barplot, binom_damage + 0.025 , paste(round(binom_damage*100),"%", sep=""),cex=1)

  })
  #Cumulativ Damage plot
  output$cumulativ_probDens <- renderPlot({


    #Get the initial number of damage using the damage characteristic of the weapon
    nb_wounds <- get_wound_count(input$NumberHits,input$Damage)

    #Get the binomial probability associated with wounds
    binom_damage = dbinom(seq(0,nb_wounds),nb_wounds,prob=binom_prob())

    #Removing the prob value for damage 0 since it won't be need for the cumulative representation.
    binom_damage <- binom_damage[-1]
    binom_cumulativ = rep(0,length(binom_damage))
    for(i in 1:length(binom_damage)){
      binom_cumulativ[i] <- sum(binom_damage[i:length(binom_damage)])
    }
    # draw the histogram with the probability to do at least X damage
    cumulativ_damage_barplot <- barplot(binom_cumulativ,names.arg = seq(1,get_wound_count(input$NumberHits,input$Damage)),col="#69b3a2",ylim = c(0,max(binom_cumulativ)+0.05))
    text(cumulativ_damage_barplot, binom_cumulativ + 0.025 , paste(round(binom_cumulativ*100),"%", sep=""),cex=1)

  })
  output$kill_dens <- renderPlot({

    #Get the binom prob
    prob_binom <- binom_prob()
    # get the initial kill count from which the dbinom will be computed
    nb_kills <- get_kill_count(hits, input$Damage, input$TargetLifePoints)

    #Get the prob to kill a model
    binom_kill <- dbinom(seq(0,nb_kills),nb_kills,prob=prob_binom)

    # draw the histogram with the specified number of bins
    kill_barplot <- barplot(binom_kill,names.arg = seq(0,nb_kills),col="#69b3a2",ylim = c(0,max(binom_kill)+0.05))
    text(kill_barplot, binom_kill + 0.025 , paste(round(binom_kill*100),"%", sep=""),cex=1)
  })



  output$cumulativ_kill_dens <- renderPlot({

    #Get the binom prob
    prob_binom <- binom_prob()
    # get the initial kill count from which the dbinom will be computed
    nb_kills <- get_kill_count(hits, input$Damage, input$TargetLifePoints)

    #Get the prob to kill a model
    binom_kill <- dbinom(seq(1,nb_kills),nb_kills,prob=prob_binom)

    binom_cumulativ = rep(0,length(binom_kill))
    for(i in 1:length(binom_kill)){
      binom_cumulativ[i] <- sum(binom_kill[i:length(binom_kill)])
    }
    # draw the histogram with the specified number of bins
    cumulativ_kill_barplot <- barplot(binom_cumulativ,names.arg = seq(1,nb_kills),col="#69b3a2",ylim = c(0,max(binom_cumulativ)+0.05))
    text(cumulativ_kill_barplot, binom_cumulativ + 0.025 , paste(round(binom_cumulativ*100),"%", sep=""),cex=1)
  })
}
