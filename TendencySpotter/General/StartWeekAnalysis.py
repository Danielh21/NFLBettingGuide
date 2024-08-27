import sys
import pandas as pd
import sqlite3

# Check if the correct number of arguments has been provided
if len(sys.argv) != 2:
    print("Can't run without a parameter")
    sys.exit(1)  # Exit with an error code

# Access the parameter
parameter = sys.argv[1]

print(parameter)

# Use the parameter with f-string formatting
print(f"The week your entered is  {parameter} - Getting all games from week")


db_name = '../../nfl_2024_schedule.db'
conn = sqlite3.connect(db_name)

table_name = 'nfl_schedule'

# Define the SQL query using the parameter
query = f"SELECT * FROM {table_name} WHERE week = ?"

# Execute the query using the parameter
try:
    # Use a parameterized query to avoid SQL injection
    df = pd.read_sql_query(query, conn, params=(parameter,))
    
    # Display the results
    print(df)
except Exception as e:
    print(f"An error occurred: {e}")
finally:
    # Close the database connection
    conn.close()