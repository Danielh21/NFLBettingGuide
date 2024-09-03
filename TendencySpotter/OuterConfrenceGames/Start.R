library(here)
setwd(here())
print(getwd())
source("setup.R")
source(file.path("TendencySpotter", "WriteToScheduledDatabase.r"))
library(RSQLite)
library(DBI)
library(tictoc)
library(nflfastR)
library(dplyr, warn.conflicts = FALSE)

# Now you can use the options set in setup.R
db_directory <- getOption("nflfastR.dbdirectory")

db_file <- file.path(db_directory, "tendencies.db")

# Connect to the SQLite database
con <- dbConnect(RSQLite::SQLite(), dbname = db_file)

# List all tables in the database
tables <- dbListTables(con)

id_value <- 2  # Tendecy id

data <- dplyr::tbl(con, "nflfastR_pbp")

# NFC teams
NFC <- c("ARI", "ATL", "CAR", "CHI", "DAL", "DET", "GB", "LA", "MIN", "NO", "NYG", "PHI", "SEA", "SF", "TB", "WAS")

# AFC teams
AFC <- c("BAL", "BUF", "CIN", "CLE", "DEN", "HOU", "IND", "JAX", "KC", "LAC", "LV", "MIA", "NE", "NYJ", "PIT", "TEN")


analysis_past_data <- function(con) {
    game_outerconfrence_home_dog <- data %>%
    filter(season >= 2019 & season <= 2024, (home_team %in% NFC & away_team %in% AFC) | (home_team %in% AFC & away_team %in% NFC) ) %>%   # Filter for positive home team spread line
    arrange(game_id) %>%   # Arrange by game_id to ensure ordering
    distinct(game_id, .keep_all = TRUE)%>%    # Keep one row per game_id
    select(home_team, away_team, home_score, away_score, spread_line, season, week )%>% 
    mutate(
      cover = case_when(  # Determine if favorite covered, home dog covered, or push
        spread_line < 0 & (home_score - away_score) > spread_line ~ 1,  # Favorite (home) covered
        spread_line > 0 & (home_score - away_score) > spread_line ~ 1,   # Home underdog covered
        spread_line < 0 & (home_score - away_score) < spread_line ~ -1,  # Favorite (home) covered
        spread_line > 0 & (home_score - away_score) < spread_line ~ -1,   # Home underdog covered
        (home_score - away_score) == spread_line ~ 0                                # Push
      )
    )

  head(game_outerconfrence_home_dog)


  summary_table <- game_outerconfrence_home_dog %>%
    summarize(
      id = id_value,
      text_describtion = 'Outer confrence game. Analysis team is the favirote. Favirote is [analysis_team_cover]-[analysis_team_not_cover]-[pushes] in outerconfrence games since 2019',
      tendecyName = 'Outer confrence game',
      games_included = n(),  # Total number of games analyzed
      analyis_team_cover = sum(cover == 1),  # Count of games where home team covered
      analysis_team_not_cover = sum(cover == -1), # Count of games where away team covered
      pushes = sum(cover == 0)  # Count of pushes
    )

  print(summary_table)


  summary_df <- as.data.frame(summary_table)

  write_summary_to_db(summary_df, id_value)
  print("Added tendency to database succesfully")
}

analysis_upcoming_week <- function(con, week) {
  nfl_schedule <- dplyr::tbl(con, "nfl_schedule_2024")

  upcoming_games <- nfl_schedule %>%
    filter(season == 2024, 
           week == !!week, 
           (home_team %in% NFC & away_team %in% AFC) | (home_team %in% AFC & away_team %in% NFC) 
           ) %>%
    select(home_team, game_id, away_team, home_score, away_score, spread_line, season, week )%>% 
    arrange(game_id) %>%
    collect()

  custom_df <- data.frame(
  tendecy_id = numeric(),
  nfl_schedule_game_id = character(),
  analyis_team_is_home_team = integer(),
  stringsAsFactors = FALSE
)

for (i in 1:nrow(upcoming_games)) {
  current_game <- upcoming_games[i, ]
  new_row <- data.frame(
    tendecy_id = id_value,
    nfl_schedule_game_id = current_game$game_id,
    analyis_team_is_home_team = if_else(current_game$spread_line > 0, 1L, 0L)
  )
  custom_df <- rbind(custom_df, new_row)
}

for (i in 1:nrow(custom_df)) {
  write_game_to_tendecy_map(custom_df[i, ], id_value)
}
print("Added games for week to tendency map")

}


# Starts the running of here 
args <- commandArgs(trailingOnly = TRUE)

insertToDatabase <- FALSE
weekToAnalysis <- 0
runWeekAnalysis <- FALSE



if (length(args) >= 1) {
  if(args[1] > 0) {
    insertToDatabase <- TRUE
    cat("Parameter 1 is set to:", args[1], "\n")
  }
}

if (length(args) >= 1) {
  weekToAnalysis <-  args[2]
  runWeekAnalysis <- TRUE
  cat("Week To Analysis: ", args[2], "\n")
}


if(insertToDatabase) {
  analysis_past_data(con)
}

if(runWeekAnalysis) {
  analysis_upcoming_week(con, weekToAnalysis)
}

  ##
  dbDisconnect(con)