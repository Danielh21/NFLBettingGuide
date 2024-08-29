library(DBI)
library(RSQLite)
library(nflreadr)
setwd("C:/Users/DanielHollmann/source/NFL.Predictions/")
print(getwd())
nfl_schedule_2024 <- load_schedules(seasons = 2024)
head(nfl_schedule_2024)
con <- dbConnect(RSQLite::SQLite(), dbname = "nfl_2024.db")
# Write the data frame to a table in the SQLite database
dbWriteTable(con, name = "nfl_schedule_2024", value = nfl_schedule_2024, overwrite = TRUE)
# Disconnect from the database
dbDisconnect(con)
