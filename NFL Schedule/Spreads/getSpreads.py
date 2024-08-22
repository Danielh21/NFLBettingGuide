from dotenv import load_dotenv
import os
import requests
import sqlite3
from processSingleSpread import process_spread



load_dotenv()

apikey = os.getenv("API_KEY")

# response = requests.get(f"https://api.the-odds-api.com/v4/sports/americanfootball_nfl/odds?regions=eu&oddsFormat=decimal&apiKey={apikey}&markets=spreads&sport=americanfootball_nfl")

# json_data = response.json()

json_data = [
    {
        "id": "612c2c3f6ca9e10d4b7ead21a2b0ff38",
        "sport_key": "americanfootball_nfl",
        "sport_title": "NFL",
        "commence_time": "2024-09-06T00:20:00Z",
        "home_team": "Kansas City Chiefs",
        "away_team": "Baltimore Ravens",
        "bookmakers": [
            {
                "key": "betonlineag",
                "title": "BetOnline.ag",
                "last_update": "2024-08-22T13:45:10Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:10Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 1.83,
                                "point": 3.0
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 2.0,
                                "point": -3.0
                            }
                        ]
                    }
                ]
            },
            {
                "key": "sport888",
                "title": "888sport",
                "last_update": "2024-08-22T13:45:10Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:10Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 2.0,
                                "point": 2.5
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 1.8,
                                "point": -2.5
                            }
                        ]
                    }
                ]
            },
            {
                "key": "pinnacle",
                "title": "Pinnacle",
                "last_update": "2024-08-22T13:45:10Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:10Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 1.86,
                                "point": 3.0
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 2.06,
                                "point": -3.0
                            }
                        ]
                    }
                ]
            },
            {
                "key": "onexbet",
                "title": "1xBet",
                "last_update": "2024-08-22T13:45:10Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:10Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 2.0,
                                "point": 2.5
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 1.8,
                                "point": -2.5
                            }
                        ]
                    }
                ]
            },
            {
                "key": "coolbet",
                "title": "Coolbet",
                "last_update": "2024-08-22T13:45:11Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:11Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 2.0,
                                "point": 2.5
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 1.85,
                                "point": -2.5
                            }
                        ]
                    }
                ]
            },
            {
                "key": "gtbets",
                "title": "GTbets",
                "last_update": "2024-08-22T13:45:14Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:14Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 2.01,
                                "point": 2.5
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 1.84,
                                "point": -2.5
                            }
                        ]
                    }
                ]
            },
            {
                "key": "everygame",
                "title": "Everygame",
                "last_update": "2024-08-22T13:45:12Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:11Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 1.83,
                                "point": 3.0
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 2.0,
                                "point": -3.0
                            }
                        ]
                    }
                ]
            },
            {
                "key": "betanysports",
                "title": "BetAnySports",
                "last_update": "2024-08-22T13:45:12Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:12Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 2.0,
                                "point": -2.5
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 1.83,
                                "point": 2.5
                            }
                        ]
                    }
                ]
            },
            {
                "key": "tipico_de",
                "title": "Tipico",
                "last_update": "2024-08-22T13:45:15Z",
                "markets": [
                    {
                        "key": "spreads",
                        "last_update": "2024-08-22T13:45:15Z",
                        "outcomes": [
                            {
                                "name": "Baltimore Ravens",
                                "price": 2.0,
                                "point": 2.5
                            },
                            {
                                "name": "Kansas City Chiefs",
                                "price": 1.77,
                                "point": -2.5
                            }
                        ]
                    }
                ]
            }
        ]
    }
]

db_name = './nfl_2024_schedule.db'
abs_path = os.path.abspath(db_name)
print(f"Connecting to database at: {abs_path}")
conn = sqlite3.connect(db_name)

for game in json_data:
    process_spread(game, conn)