# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
golem::fill_desc(
  pkg_name = "DamageSimulatorW40K", # The Name of the package containing the App
  pkg_title = "A ShinyApp to know what to expect when you shoot at things in W40K", # The Title of the package containing the App
  pkg_description = "In this app, you can easily compute the damage output of any weapons against any targets.
  Just use the sliders to adjust the parameters and it will produce data to help guide your decisions.
  It uses a binomial distribution with a probability computed with the parameters given.
  You'll be served graphs (probability density of the binomial for those of you stats enclined)
  giving you the probability to wound a certain amount of damages with some usefull extra stats displayed.", # The Description of the package containing the App
  author_first_name = "Adrien", # Your First Name
  author_last_name = "Foucal", # Your Last Name
  author_email = "adrien.foucal@gmail.com", # Your Email
  repo_url = "https://github.com/Adrien-Evo/DamageSimulatorW40K.git" # The URL of the GitHub Repo (optional)
)

## Set {golem} options ----
golem::set_golem_options()

## Create Common Files ----
## See ?usethis for more information
usethis::use_mit_license("Golem User") # You can set another license here
usethis::use_readme_rmd(open = FALSE)
# Note that `contact` is required since usethis version 2.1.5
# If your {usethis} version is older, you can remove that param
usethis::use_code_of_conduct(contact = "Golem User")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)

## Use git ----
usethis::use_git()

## Init Testing Infrastructure ----
## Create a template for tests
golem::use_recommended_tests()

## Favicon ----
# If you want to change the favicon (default is golem's one)
golem::use_favicon("C:\\Users\\Adrien\\Downloads\\target.png")
# golem::remove_favicon() # Uncomment to remove the default favicon
#Vitaly Gorbachev
  ## Add helper functions ----
golem::use_utils_ui(with_test = TRUE)
golem::use_utils_server(with_test = TRUE)

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile("dev/02_dev.R")
