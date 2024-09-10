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

id_value <- 3  # Tendecy id

data <- dplyr::tbl(con, "nflfastR_pbp")



analysis_past_data <- function(con) {
    tomlin_as_dog <- data %>%
    filter(season >= 2007 & season <= 2024, (home_coach == 'Mike Tomlin' | away_coach == 'Mike Tomlin')) %>%   # Filter for positive home team spread line
    filter((home_coach == 'Mike Tomlin' & spread_line < 0) | (away_coach == 'Mike Tomlin' & spread_line > 0)) %>%
    arrange(game_id) %>%   # Arrange by game_id to ensure ordering
    distinct(game_id, .keep_all = TRUE)%>%    # Keep one row per game_id
    select(home_team, away_team, home_score, away_score, spread_line, season, home_coach, away_coach,  week )%>%
        mutate(
      cover = case_when(  # Determine if favorite covered, home dog covered, or push
        away_coach == 'Mike Tomlin' & (away_score + spread_line) > home_score ~ 1,  # If Tomlin is the home coach and home is underdog, check if home covered
        home_coach == 'Mike Tomlin' & (home_score + spread_line) > away_score ~ 1,   # If Tomlin is the away coach and away is underdog, check if away covered
        (home_score - away_score) == spread_line ~ 0,                              # Push
        TRUE ~ -1  # Favorite team covered
      )
    )

  head(tomlin_as_dog)


  summary_table <- tomlin_as_dog %>%
    summarize(
      id = id_value,
      text_describtion = 'Tomlin as a dog. Tomlins team is [analysis_team_cover]-[analysis_team_not_cover]-[pushes] when his team are underdogs since 2007',
      tendecyName = 'Tomlin as a dog',
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



analysis_past_data(con)

  ##
  dbDisconnect(con)