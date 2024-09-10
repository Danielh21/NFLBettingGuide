import sys
import pandas as pd
import sqlite3
from DivisionHomeDogs.analyseGame  import anaylse_game_divison_dog
from OuterConfrenceGames.analyseGame import analyse_outer_confrence_game

# Check if the correct number of arguments has been provided
if len(sys.argv) != 2:
    print("Can't run without a parameter")
    sys.exit(1)  # Exit with an error code

# Access the parameter
parameter = sys.argv[1]

# Use the parameter with f-string formatting
print(f"The week your entered is  {parameter} - Getting all games from week")


db_name = '../tendencies.db'
conn = sqlite3.connect(db_name)

table_name = 'nfl_schedule_2024'

# Define the SQL query using the parameter
query = f"SELECT * FROM {table_name} WHERE week = ? and season = 2024"

# Execute the query using the parameter
try:
    # Use a parameterized query to avoid SQL injection
    df = pd.read_sql_query(query, conn, params=(parameter))

    for index, row in df.iterrows():
        anaylse_game_divison_dog(row, conn)
        analyse_outer_confrence_game(row, conn)

except Exception as e:
    print(f"An error occurred: {e}")
finally:
    # Close the database connection
    conn.close()