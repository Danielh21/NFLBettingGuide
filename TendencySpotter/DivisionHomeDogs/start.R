setwd("C:/Users/DanielHollmann/source/NFL.Predictions/")
print(getwd())
source("setup.R")
library(RSQLite)
library(DBI)
library(tictoc)
library(nflfastR)
library(dplyr, warn.conflicts = FALSE)

# Now you can use the options set in setup.R
db_directory <- getOption("nflfastR.dbdirectory")

db_file <- file.path(db_directory, "pbp_db")

# Connect to the SQLite database
con <- dbConnect(RSQLite::SQLite(), dbname = db_file)

# List all tables in the database
tables <- dbListTables(con)


data <- dplyr::tbl(con, "nflfastR_pbp")

games_with_positive_spread <- data %>%
  filter(season >= 2022 & season <= 2024, spread_line > 0) %>%   # Filter for positive home team spread line
  arrange(game_id) %>%   # Arrange by game_id to ensure ordering
  distinct(game_id, .keep_all = TRUE)%>%    # Keep one row per game_id
  select(home_team, away_team, home_score, away_score, spread_line)%>% 
  mutate(cover = case_when(   # Determine if home team covered the spread
    (home_score - away_score) > spread_line ~ 1,  # Home team covered
    (home_score - away_score) == spread_line ~ 0, # Push
    (home_score - away_score) < spread_line ~ -1  # Away team covered
  ))


id_value <- 1  # Tendecy id

# Summarize the data to get the counts of each outcome
summary_table <- games_with_positive_spread %>%
  summarize(
    id = id_value,
    tendecyName = 'Home games where home team are underdogz',
    games_included = n(),  # Total number of games analyzed
    analyis_team_cover = sum(cover == 1),  # Count of games where home team covered
    analysis_team_not_cover = sum(cover == -1), # Count of games where away team covered
    pushes = sum(cover == 0)  # Count of pushes
  )

# print(games_with_positive_spread, n = 2000)

# Print the summary table
print(summary_table)

scheduled_file <- file.path(db_directory, "nfl_2024_schedule.db")

scheduled_con <- dbConnect(RSQLite::SQLite(), dbname = scheduled_file)

summary_df <- as.data.frame(summary_table)

# Delete the existing row with the specified id (if it exists)
dbExecute(scheduled_con, paste0("DELETE FROM tendency WHERE id = ", id_value))

dbWriteTable(scheduled_con, 'tendency', summary_df, append = TRUE, row.names = FALSE)

##
dbDisconnect(con)
dbDisconnect(scheduled_con)
