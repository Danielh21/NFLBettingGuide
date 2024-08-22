select DISTINCT season, home_team, home_score, away_team, away_score, game_seconds_remaining, home_team, play_type, posteam, spread_line, div_game
from nflfastR_pbp
where season = 2023 and 
week = 17 and game_seconds_remaining = 3600 and
play_type = 'kickoff'
LIMIT 100