setwd("C:/Users/DanielHollmann/source/NFL.Predictions/")
print(getwd())
source("setup.R")
source(file.path("TendencySpotter", "General", "WriteToScheduledDatabase.r"))
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


data <- dplyr::tbl(con, "nflfastR_pbp")

game_with_negative_spread <- data %>%
  filter(season >= 2022 & season <= 2024, spread_line < 0, div_game == 1) %>%   # Filter for positive home team spread line
  arrange(game_id) %>%   # Arrange by game_id to ensure ordering
  distinct(game_id, .keep_all = TRUE)%>%    # Keep one row per game_id
  select(home_team, away_team, home_score, away_score, spread_line, season, week )%>% 
  mutate(cover = case_when(   # Determine if home team covered the spread
    (home_score - away_score) > spread_line ~ 1,  # Home team covered
    (home_score - away_score) == spread_line ~ 0, # Push
    (home_score - away_score) < spread_line ~ -1  # Away team covered
  ))


id_value <- 1  # Tendecy id

# Summarize the data to get the counts of each outcome
summary_table <- game_with_negative_spread %>%
  summarize(
    id = id_value,
    text_describtion = 'Division games where home team are underdogs. Analysis team is the home team. Division dogs are [analysis_team_cover]-[analysis_team_not_cover]-[pushes] in games where the home team are underdog since 2022',
    tendecyName = 'Division home underdog',
    games_included = n(),  # Total number of games analyzed
    analyis_team_cover = sum(cover == 1),  # Count of games where home team covered
    analysis_team_not_cover = sum(cover == -1), # Count of games where away team covered
    pushes = sum(cover == 0)  # Count of pushes
  )

# print(game_with_negative_spread, n = 2000)

# Print the summary table
print(summary_table)

summary_df <- as.data.frame(summary_table)

write_summary_to_db(summary_df, id_value)

##
dbDisconnect(con)
print("Added tendency to database succesfully")