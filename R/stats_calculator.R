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




#' Get the roll needed to wound
#'
#' @param ST Weapon strength.
#' @param TO Toughness of the target.
#' @return Needed wound roll
#' @examples
#' get_strength_toughness_prob(4, 4)
#' get_strength_toughness_prob(10,5)
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

get_binom_prob <- function(prob_hit,prob_wound,prob_go_trough_save){

  prob = prob_hit
  prob = prob * prob_wound
  prob = prob * prob_go_trough_save
  return(prob)
}
get_binom_prob_old <- function(hit,strength,toughness,armor){

  prob = 1-(hit-1)/6
  prob = prob * (1-((get_strength_toughness_prob(strength,toughness)-1)/6))
  prob = prob * ((armor-1)/6)
  return(prob)
}
#' Get the probability needed to hit
#'
#' @param hit Ballistic skill or Weapon skill. It's a roll needed
#' @return Probability to hit
#' @examples
#' get_prob_hit(5)
#' get_prob_hit(2)
get_prob_hit <- function(hit){
  prob = 1-(hit-1)/6
  return(prob)
}

#' Get the probability needed to wound
#'
#' @param strength Weapon strength.
#' @param toughness Toughness of the target.
#' @return Probability to wound
#' @examples
#' get_prob_wound(4, 4)
#' get_prob_wound(4, 8)
get_prob_wound <- function(strength,toughness){
  prob = 1-((get_strength_toughness_prob(strength,toughness)-1)/6)
  return(prob)
}

#' Get the probability for a wound to go througth knowing the save of the opponent
#'
#' @param armorsave Armor save in the datasheet
#' @return Probability for a wound to go through knowing the target armor save
#' @examples
#' get_prob_save(4)
#' get_prob_save(2)
get_prob_save <- function(armorsave){
  prob = (armorsave-1)/6
  return(prob)
}

#' Get the number of dead units knowing how many wounds have been dealt, with how many damage per shots and the target's wound characteristic
#'
#' @param nbwounds Total number of wounds dealt after hitting, wounding and armorsaving
#' @param damage Damage profile of the weapon
#' @param lifepoints Total wounds of the model
#' @return Number of dead model
#' @examples
#' get_prob_save(4)
#' get_prob_save(2)
get_kill_count <- function(nbwounds, damage, lifepoints){
  bodycount = nbwounds/(ceiling(lifepoints/damage))
  return(floor(bodycount))
}

# get_kill_count(40,1,3)
# #hit = 4
# #wound = 4
# #armor = 4
# #toughness = 4
# hits <- 4
# prob_hit <- 4
# prob_wound <- get_prob_wound(4,4)
# prob_go_through_save <- get_prob_save(3)
# #Combine all prob using get_prob_save
# prob_binom <- get_binom_prob(prob_hit,prob_wound,prob_go_through_save)
# prob_binom
# #plot(seq(1,40),dbinom(seq(1,40),40,prob=pp),type='h')

