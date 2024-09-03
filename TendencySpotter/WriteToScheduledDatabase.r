write_summary_to_db <- function(summary_df, id_value) {
  # Load necessary libraries
  library(DBI)
  library(RSQLite)
  
  scheduled_file <- file.path(db_directory, "tendencies.db")
  
  scheduled_con <- dbConnect(RSQLite::SQLite(), dbname = scheduled_file)
  
  # Connect to the second database
  scheduled_con <- dbConnect(RSQLite::SQLite(), dbname = scheduled_file)
  
  # Delete the existing row with the specified id (if it exists)
  dbExecute(scheduled_con, paste0("DELETE FROM tendency WHERE id = ", id_value))
  
  # Insert the new row
  dbWriteTable(scheduled_con, 'tendency', summary_df, append = TRUE, row.names = FALSE)
  
}


write_game_to_tendecy_map <- function(dataframe, id_value) {
    # Load necessary libraries
  library(DBI)
  library(RSQLite)

  gameid <- dataframe$nfl_schedule_game_id
  
  scheduled_file <- file.path(db_directory, "tendencies.db")
  
  scheduled_con <- dbConnect(RSQLite::SQLite(), dbname = scheduled_file)

  delete_query <- "DELETE FROM tendecy_game_map WHERE tendecy_id = ? AND nfl_schedule_game_id = ?"

  dbExecute(scheduled_con, delete_query, params = list(id_value, gameid))
  
  # Insert the new row
  dbWriteTable(scheduled_con, 'tendecy_game_map', dataframe, append = TRUE, row.names = FALSE)
  

}