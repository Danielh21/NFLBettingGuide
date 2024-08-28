from dotenv import load_dotenv
import os
import requests
import sqlite3
from processSingleSpread import process_spread



load_dotenv()

apikey = os.getenv("API_KEY")

response = requests.get(f"https://api.the-odds-api.com/v4/sports/americanfootball_nfl/odds?regions=eu&oddsFormat=decimal&apiKey={apikey}&markets=spreads&sport=americanfootball_nfl")

json_data = response.json()

db_name = '../../nfl_2024_schedule.db'
abs_path = os.path.abspath(db_name)
print(f"Connecting to database at: {abs_path}")
conn = sqlite3.connect(db_name)

for game in json_data:
    process_spread(game, conn)

conn.close()