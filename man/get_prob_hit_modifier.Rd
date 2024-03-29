% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats_calculator.R
\name{get_prob_hit_modifier}
\alias{get_prob_hit_modifier}
\title{Get the probability needed to hit with modifier without explode}
\usage{
get_prob_hit_modifier(hit, modif, rerolls)
}
\arguments{
\item{hit}{Ballistic skill or Weapon skill. It's a roll needed}

\item{modif}{Ballistic skill or Weapon skill. It's a roll needed}

\item{rerolls}{Ballistic skill or Weapon skill. It's a roll needed}
}
\value{
Probability to hit
}
\description{
Get the probability needed to hit with modifier without explode
}
\examples{
get_prob_hit_modifier(5)
get_prob_hit_modifier(2)
}
