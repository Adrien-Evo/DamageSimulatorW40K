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
#' Combine all probabilities to get our prob density
#'
#' @param hit Prob to hit, prob to wound and the pro to go through armor
#' @return combined probability
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

#' Get the probability needed to hit with modifier without explode
#'
#' @param hit Ballistic skill or Weapon skill. It's a roll needed
#' @param modif Ballistic skill or Weapon skill. It's a roll needed
#' @param rerolls Ballistic skill or Weapon skill. It's a roll needed
#' @return Probability to hit
#' @examples
#' get_prob_hit_modifier(5)
#' get_prob_hit_modifier(2)
get_prob_hit_modifier <- function(hit,modif,rerolls){
  prob = 1-(hit-1 - modif)/6 + (1-(hit-1 - modif)/6)*rerolls
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

#' Get the probability for a wound to go through knowing the save of the opponent
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
#' Get the number of wounds possible using the damages per shot.
#'
#' @param nbwounds Total number of wounds dealt after hitting, wounding and armorsaving
#' @param damage Damage profile of the weapon
#' @return Number of dead model
#' @examples
#' get_wound_count(4)
#' get_wound_count(2)
get_wound_count <- function(nbwounds, damage){
  wound_count = nbwounds*damage
  return(wound_count)
}

#' Get the number of dead units knowing how many wounds have been dealt, with how many damages per shot and the target's wound characteristic
#'
#' @param nbwounds Total number of wounds dealt after hitting, wounding and armorsaving
#' @param damage Damage profile of the weapon
#' @param lifepoints Total wounds of the model
#' @return Number of dead model
#' @examples
#' get_kill_count(4)
#' get_kill_count(2)
get_kill_count <- function(nbwounds, damage, lifepoints){
  body_count = nbwounds/(ceiling(lifepoints/damage))
  return(floor(body_count))
}


#######Testing

hits <- 10
prob_hit <- get_prob_hit(3)
prob_wound <- get_prob_wound(4,4)
prob_go_through_save <- get_prob_save(3)

#Get the initial number of damage using the damage characteristic of the weapon
nb_wounds <- get_wound_count(hits,1)

#Combine all prob using get_prob_save
prob_binom <- get_binom_prob(prob_hit,prob_wound,prob_go_through_save)

# Get the prob to damage a model
binom_damage <- dbinom(seq(0,nb_wounds),nb_wounds,prob=prob_binom)


# draw the histogram with the specified number of bins
damage_barplot <- barplot(binom_damage,names.arg = seq(0,hits),col="#69b3a2",ylim = c(0,max(binom_damage)+0.05))
text(damage_barplot, binom_damage + 0.025 , paste(round(binom_damage*100),"%", sep=""),cex=1)

binom_cumulativ = rep(0,length(binom_damage))
for(i in 1:length(binom_damage)){
  binom_cumulativ[i] <- sum(binom_damage[i:length(binom_damage)])
}

cumulativ_damage_barplot <- barplot(binom_cumulativ,names.arg = seq(0,hits),col="#69b3a2",ylim = c(0,max(binom_cumulativ)+0.05))
text(cumulativ_damage_barplot, binom_cumulativ + 0.025 , paste(round(binom_cumulativ*100),"%", sep=""),cex=1)

