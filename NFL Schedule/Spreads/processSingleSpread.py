import sqlite3

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

        update_query = """
            UPDATE nfl_schedule
            SET spread_line = ?
            WHERE game_id = ?
            """
        cursor.execute(update_query, (home_spread, gameID))
        conn.commit()
        print(f"Updated {gameID} with spreadLine: {home_spread}")
        
    
    print("-----------")



def get_home_spread(game):
    # TODO IMPLEMENT
    return 3.2