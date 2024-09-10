import sqlite3
from termcolor import colored

def analyse_outer_confrence_game(game, conn : sqlite3.Connection):

    # NFC teams
    NFC = ["ARI", "ATL", "CAR", "CHI", "DAL", "DET", "GB", "LA", "MIN", "NO", "NYG", "PHI", "SEA", "SF", "TB", "WAS"]

    # AFC teams
    AFC = ["BAL", "BUF", "CIN", "CLE", "DEN", "HOU", "IND", "JAX", "KC", "LAC", "LV", "MIA", "NE", "NYJ", "PIT", "TEN"]

    is_NFC_vs_AFC = (game['home_team'] in NFC and game['away_team'] in AFC) or (game['home_team'] in AFC and game['away_team'] in NFC)


    print(colored(f"Game {game['home_team']} - {game['away_team']}  {game['spread_line']}", "green"))
    tendency_id = 2
    if(game['spread_line'] is None):
        print("Game does not have spread_line")
        return
    # Should insert if the game is a division game and the home team is a dog
    if (is_NFC_vs_AFC):
        print(colored(f"Game should count {game['home_team']} - {game['away_team']} ", "green"))

        queryToCheckIfExits = "select * from tendecy_game_map  where nfl_schedule_game_id = ? and tendecy_id  = ?"
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()

        cursor.execute(queryToCheckIfExits, (game['game_id'],  tendency_id))

        row = cursor.fetchone()

        # if spread line is positive, the home team is favriote
        homeTeamfav = game['spread_line'] > 0

        if row is None:
            #Insert
            insertQuery = "insert into tendecy_game_map VALUES (?,?, ?) "
            conn.execute(insertQuery, (tendency_id, game['game_id']), homeTeamfav)
            print(colored(f"Game Tendency Added to DB {game['home_team']} - {game['away_team']} ", "green"))
            conn.commit()

        
        if row is not None:
            print(f"Already exitis in DB {game['home_team']} - {game['away_team']} ")

