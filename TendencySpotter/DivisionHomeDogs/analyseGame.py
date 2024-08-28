import sqlite3
from termcolor import colored

def anaylse_game_divison_dog(game, conn : sqlite3.Connection):

    tendency_id = 1
    
    # Should insert if the game is a division game and the home team is a dog
    if (game['spread_line'] > 0 & game['div_game']):
        print(colored(f"Game should count {game['home_team']} - {game['away_team']} ", "green"))

        queryToCheckIfExits = "select * from tendecy_game_map  where nfl_schedule_game_id = ? and tendecy_id  = ?"
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()

        cursor.execute(queryToCheckIfExits, (game['game_id'],  tendency_id))

        row = cursor.fetchone()

        if row is None:
            #Insert
            insertQuery = "insert into tendecy_game_map VALUES (?,?) "
            conn.execute(insertQuery, (tendency_id, game['game_id']))
            print(colored(f"Game Tendency Added to DB {game['home_team']} - {game['away_team']} ", "green"))
            conn.commit()

        
        if row is not None:
            print(f"Already exitis in DB {game['home_team']} - {game['away_team']} ")

