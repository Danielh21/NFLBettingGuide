source("setup.R")
setwd("C:/Users/DanielHollmann/source/NFL.Predictions/")
nflfastR::update_db(dbdir = getOption("nflfastR.dbdirectory", default = "C:/Users/DanielHollmann/source/NFL.Predictions"),dbname = "tendencies.db",)

library(DBI)
library(RSQLite)
library(nflreadr)
print(getwd())
nfl_schedule_2024 <- load_schedules(seasons = 2024)
head(nfl_schedule_2024)
con <- dbConnect(RSQLite::SQLite(), dbname = "tendencies.db")
# Write the data frame to a table in the SQLite database
dbWriteTable(con, name = "nfl_schedule_2024", value = nfl_schedule_2024, overwrite = TRUE)
# Disconnect from the database
print("Saved NFL Schedule_2024")
dbDisconnect(con)
