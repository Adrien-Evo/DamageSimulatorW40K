#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
##Reading XML
#library(XML)

#necron <- xmlParse("W40K/Necrons.cat")
#xml_necron <- xmlToList(necron)

##Getting a graph simply
#We assume EQM : equivalent marines saves 3+ toughness 4
#Probability = 20/216 3+ =1-  3-1/6 * 1-3/6 *5/6 ==wound
####TOughness = 4 for the moment

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

get_prob_hit <- function(hit){
  prob = 1-(hit-1)/6
  return(prob)
}

get_prob_wound <- function(strength,toughness){
  prob = 1-((get_strength_toughness_prob(strength,toughness)-1)/6)
  return(prob)
}

get_prob_save <- function(armorsave){
  prob = (armorsave-1)/6
  return(prob)
}

get_kill_count <- function(nbwounds, damage, lifepoints){
  bodycount = nbwounds/(ceiling(lifepoints/damage))
  return(floor(bodycount))
}
#hit = 4
#wound = 4
#armor = 4
#toughness = 4
#pp = get_binom_prob(hit,wound,toughness,armor)
#pp

#plot(seq(1,40),dbinom(seq(1,40),40,prob=pp),type='h')

# Define UI for application that draws a histogram
ui <- fluidPage(
      theme = shinytheme("darkly"),
      titlePanel("DamageTesting"),
      fluidRow(
        column(4,
               "Main Characteristics",
               fluidRow(
                 column(6,
                        "DamageDealer",
                        # Copy the line below to make a slider bar
                        sliderInput("NumberHits", label = h3("Number of hits"), min = 1,
                                    max = 60, value = 10),

                        # Copy the line below to make a slider bar
                        sliderInput("WS", label = h3("Ballistic or weapon skill "), min = 1,
                                    max = 6, value = 3),


                        # Copy the line below to make a slider range
                        sliderInput("Strength", label = h3("Strength"), min = 1,
                                    max = 12 , value = 4),
                        sliderInput("Damage", label = h3("Damage"), min = 1,
                                    max = 12 , value = 4)),
                 column(6,
                        "OppositionDefense",
                        # Copy the line below to make a slider range
                        sliderInput("TargetToughness", label = h3("TargetToughness"), min = 1,
                                    max = 12, value = 4),

                        # Copy the line below to make a slider range
                        sliderInput("TargetSave", label = h3("TargetSave"), min = 1,
                                    max = 6, value = 3),
                        checkboxInput("noArmor", "No Armor Save", value = FALSE),
                        sliderInput("TargetLifePoint", label = h3("TargetLifePoints"), min = 1,
                                    max = 10, value = 2))
               )

        ),
        column(10,
               "main",
               tabsetPanel(type = "tabs",
                           tabPanel("ProbDens",plotOutput(outputId = "probDens")),
                           tabPanel("Summary", verbatimTextOutput("summary"))
               )

        )
      )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$probDens <- renderPlot({
        # generate bins based on input$bins from ui.R
        hits <- input$NumberHits
        ##Hit modifyer
        if(input$noArmor){
          armor = 7
        }else{
          armor = input$TargetSave
        }
        pp = get_binom_prob(input$WS,input$Strength,input$TargetToughness,armor)
        # draw the histogram with the specified number of bins
        plot(seq(1,hits),dbinom(seq(1,hits),hits,prob=pp),type='h')

    })
}

# Run the application
shinyApp(ui = ui, server = server)
