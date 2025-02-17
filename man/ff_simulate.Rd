% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/0_ff_simulate.R
\name{ff_simulate}
\alias{ff_simulate}
\title{Simulate Fantasy Seasons}
\usage{
ff_simulate(
  conn,
  n_seasons = 100,
  weeks_per_season = 14,
  best_ball = FALSE,
  seed = NULL,
  injury_model = c("simple", "none"),
  base_seasons = 2012:2020,
  parallel = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{conn}{an connection to a league made with \code{ff_connect()} and friends (required)}

\item{n_seasons}{number of seasons to simulate, default = 100}

\item{weeks_per_season}{number of weeks per season, default = 14}

\item{best_ball}{a logical: are weekly wins based on optimal lineups?}

\item{seed}{an integer to control reproducibility}

\item{injury_model}{select between "simple", "none"}

\item{base_seasons}{a numeric vector that selects seasons as base data, earliest available is 2012}

\item{parallel}{a logical - use parallel processing for optimizing lineups, default is FALSE}

\item{verbose}{print progress messages for debugging}
}
\description{
The main function of the package
}
\examples{
\dontrun{

conn <- mfl_connect(2021, 54040)

auto <- ff_simulate(conn)

reprex <- ff_simulate(conn = conn, seed = 613)

basic <- ff_simulate(conn = conn, n_seasons = 100, weeks_per_season = 14, best_ball = FALSE)

custom <- ff_simulate(
  conn = conn,
  n_seasons = 100,
  weeks_per_season = 17,
  custom_rankings = df_rankings,
  seed = 613,
  best_ball = FALSE,
  injury_model = c("bimodal", "separate", "none"),
  owner_efficiency = list(average = 0.75, sd = 0.025),
  verbose = FALSE
)
}

}
