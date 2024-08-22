import sqlite3

def process_spread(game, conn : sqlite3.Connection):
    """Process a single game"""
    print(f"Processing game: {game['home_team']} - {game['away_team']}")
    # Step 2: Create a connection to an SQLite database (this will create the database file if it doesn't exist)
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
        print(row)
        gameID = row["game_id"]
        print(gameID)
        
    
    print("-----------")



def get_home_spread(game):
    return 1,5