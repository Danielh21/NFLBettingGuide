import pandas as pd
import sqlite3

# Step 1: Load the CSV file into a Pandas DataFrame
file_path = 'nfl-2024-UTC-with-div-game.csv'
df = pd.read_csv(file_path)

# Step 2: Create a connection to an SQLite database (this will create the database file if it doesn't exist)
db_name = 'nfl_2024_schedule.db'
conn = sqlite3.connect(db_name)

# Step 3: Write the DataFrame to the SQLite database
table_name = 'nfl_schedule'
df.to_sql(table_name, conn, if_exists='replace', index=False)

# Close the connection
conn.close()