## Code sketching

# library(ffsimulator)
library(ffscrapr)
library(dplyr)
library(tidyr)
library(purrr)
library(arrow)

## CONNECT TO LEAGUE

conn <- mfl_connect(2021, 54040)

## DOWNLOAD SCORING HISTORY

scoring_history <- ff_scoringhistory(conn, 2006:2020)

## CALCULATES SEASON RANKS AND THE POPULATION OF PLAYER SCORES FOR THAT RANK

pos_rank <- scoring_history %>%
  group_by(season, gsis_id, mfl_id, player_name, pos, team) %>%
  summarise(
    games = dplyr::n(),
    ppg = mean(points, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  filter(
    games > 4
  ) %>%
  group_by(season, pos) %>%
  mutate(rank = rank(desc(ppg),ties.method = "random")) %>%
  ungroup() %>%
  arrange(season, pos, rank) %>%
  left_join(
    scoring_history %>% select(season, gsis_id, week, points),
    by = c("season", "gsis_id")
  ) %>%
  group_by(pos, rank) %>%
  summarise(
    all_points = list(points)
  ) %>%
  ungroup() %>%
  mutate(one_season = map(all_points, sample, size = 1000, replace = TRUE))

# fp_parquet <- tempfile()
# download.file("https://github.com/dynastyprocess/data/raw/master/files/db_fpecr.parquet",fp_parquet)

## DOWNLOADS LATEST FANTASYPROS RANKINGS

fantasypros <- arrow::read_parquet("data-raw/db_fpecr(1).parquet") %>%
  filter(ecr_type == "ro", scrape_date == max(scrape_date), pos %in% c("QB","RB","WR","TE")) %>%
  select(player, fantasypros_id = id, pos, team, ecr, sd) %>%
  group_by(pos) %>%
  mutate(rank = rank(ecr, ties.method = "random")) %>%
  ungroup()

## CONNECTS ROSTERS TO FANTASYPROS + PLAYER SCORES

rosters <- ff_rosters(conn) %>%
  select(franchise_id, franchise_name, mfl_id = player_id, player_name, pos, team, age) %>%
  left_join(dp_playerids() %>% select(fantasypros_id, mfl_id),
            by = "mfl_id") %>%
  left_join(fantasypros %>% select(fantasypros_id, rank),
            by = "fantasypros_id") %>%
  left_join(pos_rank %>% select(pos,rank,all_points),
            by = c("pos","rank")) %>%
  mutate(
    season_games = map_if(all_points,!is.na(rank), sample, size = 17, replace = TRUE)
  )

## CALCULATE OPTIMAL LINEUPS

# two paths: a) develop heuristics b) use lpSolve
# ideally solver does the optimisation

starter_positions <- ff_starter_positions(conn)

## LOGIC FOR CALCULATING STARTED LINEUPS

# a) Always choose highest ranked player by fantasypros
# b) Assume random percentage between 70-85% of optimal points

## APPLY WEEK SCORES INTO FANTASY SEASON SCHEDULES

# (use tony's ffsched package)

## CALCULATE WIN/LOSS (H2H, ALL-PLAY) + TOTAL SEASON POINTS FOR/ POTENTIAL POINTS

## figure out plots and visualizations later?

redraft_rankings <- read.csv("data-raw/fp_redraft_20162020.csv")

ppg_data <- scoring_history %>%
  group_by(season, gsis_id, mfl_id, player_name, pos, team) %>%
  summarise(
    games = dplyr::n(),
    ppg = mean(points, na.rm = TRUE)
  ) %>%
  ungroup()

preseason_adp_outcomes <- redraft_rankings %>%
  filter(!pos %in% c("K","DST")) %>%
  group_by(season, pos) %>%
  mutate(pos_rank = rank(rank_ave, ties.method = "random")) %>%
  ungroup() %>%
  left_join(
    scoring_history %>% select(sportradar_id, season, week, points) %>% filter(week <=17),
    by = c("season","sportsdata_id"="sportradar_id")
  ) %>%
  group_by(pos, pos_rank) %>%
  summarise(
    all_outcomes = list(points),
    n = dplyr::n()
  ) %>%
  ungroup() %>%
  group_by(pos) %>%
  mutate(
    missing = (5*17) - n,
    missing_na = map(missing, ~rep_len(x = 0, length.out = .x)),
    new_all_outcomes = map2(all_outcomes, missing_na, ~c(...)),
    new_n = map(new_all_outcomes, length),
    extra_outcomes = ifelse(pos_rank == 1, new_all_outcomes, numeric()),
    wide_bins = pmap(list(new_all_outcomes, lead(new_all_outcomes), lag(new_all_outcomes), extra_outcomes),~c(...)),
    wide_n = map(wide_bins, length)
  ) %>%
  ungroup()

library(slider)
library(ggridges)
library(hrbrthemes)
library(tidyverse)

preseason_adp_outcomes %>%
  filter(pos == "RB", pos_rank <= 24) %>%
  mutate(pos_rank = as.factor(pos_rank)) %>%
  unnest(wide_bins) %>%
  mutate(wide_bins = replace_na(wide_bins, 0)) %>%
  ggplot(aes(x = wide_bins, y = pos_rank, fill = pos_rank)) +
  geom_density_ridges(colour = "white",quantile_lines = TRUE) +
  # geom_density_ridges(colour = "white",stat = "binline") +
  theme_modern_rc()

preseason_adp_outcomes %>%
  mutate(
    sample_weeks = map(wide_bins, ~sample(.x,size = 17,replace = TRUE))
  ) %>%
  filter(pos == "WR", pos_rank <= 24) %>%
  mutate(pos_rank = as.factor(pos_rank)) %>%
  unnest(sample_weeks) %>%
  ggplot(aes(x = sample_weeks, y = pos_rank, fill = pos_rank)) +
  geom_density_ridges(colour = "white", quantile_lines = TRUE) +
  # geom_density_ridges(colour = "white",stat = "binline") +
  theme_modern_rc()

outcomes_rb_ppg <- pos_rank %>%
  select(-one_season) %>%
  mutate(n = map_dbl(all_points, length)) %>%
  filter(pos == "RB", rank <= 12)

outcomes_rb <- outcomes_rb_adp %>%
  rename(all_outcomes = adp_outcomes)


