import sqlite3
from termcolor import colored

def analyse_tomlin_dog(game, conn : sqlite3.Connection):

    

    awayTeam_Tomlin_underdog = (game['away_coach'] == 'Mike Tomlin' and game['spread_line'] > 0)
    homeTeam_Tomlin_underdog = (game['home_coach'] == 'Mike Tomlin' and game['spread_line'] < 0)

    print(colored(f"Game {game['home_team']} - {game['away_team']}  {game['spread_line']}", "green"))
    tendency_id = 3
    if(game['spread_line'] is None):
        print("Game does not have spread_line")
        return
    # Should insert if the game is a division game and the home team is a dog
    if (homeTeam_Tomlin_underdog or awayTeam_Tomlin_underdog):
        print(colored(f"Game should count {game['home_team']} - {game['away_team']} ", "green"))

        queryToCheckIfExits = "select * from tendecy_game_map  where nfl_schedule_game_id = ? and tendecy_id  = ?"
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()

        cursor.execute(queryToCheckIfExits, (game['game_id'],  tendency_id))

        row = cursor.fetchone()

        # if spread line is positive, the home team is favriot
        analyisTeam = 0

        if(homeTeam_Tomlin_underdog):
            analyisTeam = 1
        
        if(awayTeam_Tomlin_underdog):
            analyisTeam = 0
        

        if row is None:
            #Insert
            insertQuery = "insert into tendecy_game_map VALUES (?,?, ?) "
            conn.execute(insertQuery, (tendency_id, game['game_id'], analyisTeam))
            print(colored(f"Game Tendency Added to DB {game['home_team']} - {game['away_team']} ", "green"))
            conn.commit()

        
        if row is not None:
            print(f"Already exitis in DB {game['home_team']} - {game['away_team']} ")

