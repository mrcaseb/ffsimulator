% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/5_optimize.R
\name{ffs_optimize_lineups}
\alias{ffs_optimize_lineups}
\alias{ffs_optimise_lineups}
\title{Optimize Lineups}
\usage{
ffs_optimize_lineups(
  projected_scores,
  lineup_constraints,
  best_ball = FALSE,
  parallel = FALSE
)

ffs_optimise_lineups(
  projected_scores,
  lineup_constraints,
  best_ball = FALSE,
  parallel = FALSE
)
}
\arguments{
\item{projected_scores}{a dataframe as generated by \code{ffs_generate_predictions()} - should contain columns like: projected_score, pos, and player_id}

\item{lineup_constraints}{a dataframe as generated by \code{ffscrapr::ff_starter_positions()} - should contain columns pos, min, max, and offense_starters}

\item{best_ball}{a logical: FALSE will apply a lineup efficiency factor and TRUE uses optimal scores as actual scores, default = FALSE}

\item{parallel}{a logical: TRUE will run the optimization in parallel, requires the furrr and future packages as well as setting \code{future::plan()} in advance/externally. Default FALSE.}
}
\description{
Optimizes lineups for all franchises in the dataframe based on a table of lineup constraints
}
