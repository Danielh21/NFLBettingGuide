from dotenv import load_dotenv
import os
import requests
from processSingleSpread import process_spread



load_dotenv()

apikey = os.getenv("API_KEY")

response = requests.get(f"https://api.the-odds-api.com/v4/sports/americanfootball_nfl/odds?regions=eu&oddsFormat=decimal&apiKey={apikey}&markets=spreads&sport=americanfootball_nfl")

json_data = response.json()

for game in json_data:
    process_spread(game)