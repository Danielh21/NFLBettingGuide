setwd("C:/Users/DanielHollmann/source/NFL.Predictions/")
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

##
dbDisconnect(con)
print("Added tendency to database succesfully")