import sqlite3
from termcolor import colored

def process_spread(game, conn : sqlite3.Connection):
    """Process a single game"""
    print("-----------")
    print(f"Processing game: {game['home_team']} - {game['away_team']}")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    query = "SELECT * FROM nfl_schedule WHERE home_team = ? AND away_team = ?"

        # Execute the query
    cursor.execute(query, (game['home_team'], game['away_team']))
    
    # Fetch all the results
    row = cursor.fetchone()
    
    if row is not None:
        print(f"Found Matching game for {game['home_team']} - {game['away_team']}")
        home_spread = get_home_spread(game)
        print(f"Home Spread : {home_spread}")
        gameID = row["game_id"]
        print(f"Found game id: {gameID}")

        if(home_spread is None):
            print(colored(f"Could not find any spread for {game['home_team']} - {game['away_team']} ","red"))
            return

        update_query = """
            UPDATE nfl_schedule
            SET spread_line = ?
            WHERE game_id = ?
            """
        cursor.execute(update_query, (home_spread, gameID))
        conn.commit()
        print(colored(f"Updated {gameID} with spreadLine: {home_spread}", "green"))
        
    
    print("-----------")



def get_home_spread(game):
    # TODO IMPLEMENT
    bookmaker = find_object_by_key(game["bookmakers"], "nordicbet")
    if(bookmaker is None):
        print(f"Nordic Bet does not have lines for {game['home_team']} - {game['away_team']}")
        return None
    # print(bookmaker)
    spreads = find_object_by_key(bookmaker["markets"], "spreads")
    homeTeam = game["home_team"]
    homeSpread = find_object_by_custom_key(spreads["outcomes"], "name", homeTeam)
    return homeSpread["point"]



def find_object_by_key(json_data, search_key):
    for obj in json_data:
        if obj['key'] == search_key:
            return obj
    return None

def find_object_by_custom_key(json_data, key, search_key_value):
    for obj in json_data:
        if obj[key] == search_key_value:
            return obj
    return None