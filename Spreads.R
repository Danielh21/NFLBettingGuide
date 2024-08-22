setwd("C:/Users/DanielHollmann/source/NFL.Predictions")
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



# Filter and select the relevant data
result <- data %>%
  filter(season == 2023, 
         week == 17, 
         game_seconds_remaining == 3600, 
         play_type == "kickoff") %>%
  select(season, home_team, away_team, game_seconds_remaining, home_team, 
         play_type, posteam, spread_line, div_game) %>%
  distinct() %>%
  head(100)

# View the result
print(result, n = Inf)

