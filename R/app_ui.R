#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#'
#'
#'


library(shinythemes)

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      theme = shinytheme("united"),
      titlePanel("DamageTesting"),
      fluidRow(
        column(5,
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
                           max = 12 , value = 4)
        ),
        column(8,
               "main",
               tabsetPanel(type = "tabs",
                           tabPanel("ProbDens",plotOutput(outputId = "probDens")),
                           tabPanel("ProbDens_old", plotOutput(outputId ="probDens_old"))
               )
        ),
        column(5,
               "OppositionDefense",
               # Copy the line below to make a slider range
               sliderInput("TargetToughness", label = h3("TargetToughness"), min = 1,
                           max = 12, value = 4),

               # Copy the line below to make a slider range
               sliderInput("TargetSave", label = h3("TargetSave"), min = 1,
                           max = 6, value = 3),
               checkboxInput("noArmor", "No Armor Save", value = FALSE),
               sliderInput("TargetLifePoint", label = h3("TargetLifePoints"), min = 1,
                           max = 10, value = 2)
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "DamageSimulatorW40K"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
