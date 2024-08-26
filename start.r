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

DBI::dbListFields(con, "nflfastR_pbp") %>%
  utils::head(10)

data <- dplyr::tbl(con, "nflfastR_pbp")


## Now we can query the data - Example
data %>%
  dplyr::group_by(season) %>%
  dplyr::summarize(n = dplyr::n()) %>%
  print(n = Inf)