write_summary_to_db <- function(summary_df, id_value) {
  # Load necessary libraries
  library(DBI)
  library(RSQLite)
  
  scheduled_file <- file.path(db_directory, "nfl_2024_schedule.db")
  
  scheduled_con <- dbConnect(RSQLite::SQLite(), dbname = scheduled_file)
  
  # Connect to the second database
  scheduled_con <- dbConnect(RSQLite::SQLite(), dbname = scheduled_file)
  
  # Delete the existing row with the specified id (if it exists)
  dbExecute(scheduled_con, paste0("DELETE FROM tendency WHERE id = ", id_value))
  
  # Insert the new row
  dbWriteTable(scheduled_con, 'tendency', summary_df, append = TRUE, row.names = FALSE)
  
  # Close the database connection
  dbDisconnect(scheduled_con)
}