import pandas as pd

# Load your CSV file (replace with your actual file path)
file_path = 'nfl-2024-UTC.csv'
nfl_df = pd.read_csv(file_path)

# Define the NFL divisions
divisions = {
    'AFC East': ['Buffalo Bills', 'Miami Dolphins', 'New England Patriots', 'New York Jets'],
    'AFC North': ['Baltimore Ravens', 'Cincinnati Bengals', 'Cleveland Browns', 'Pittsburgh Steelers'],
    'AFC South': ['Houston Texans', 'Indianapolis Colts', 'Jacksonville Jaguars', 'Tennessee Titans'],
    'AFC West': ['Denver Broncos', 'Kansas City Chiefs', 'Las Vegas Raiders', 'Los Angeles Chargers'],
    'NFC East': ['Dallas Cowboys', 'New York Giants', 'Philadelphia Eagles', 'Washington Commanders'],
    'NFC North': ['Chicago Bears', 'Detroit Lions', 'Green Bay Packers', 'Minnesota Vikings'],
    'NFC South': ['Atlanta Falcons', 'Carolina Panthers', 'New Orleans Saints', 'Tampa Bay Buccaneers'],
    'NFC West': ['Arizona Cardinals', 'Los Angeles Rams', 'San Francisco 49ers', 'Seattle Seahawks'],
}

# Reverse the dictionary to map each team to its division
team_to_division = {team: division for division, teams in divisions.items() for team in teams}

# Function to check if a game is a division game
def is_division_game(row):
    home_division = team_to_division.get(row['Home Team'])
    away_division = team_to_division.get(row['Away Team'])
    return 1 if home_division == away_division else 0

# Apply the function to each row to create the 'div_game' column
nfl_df['div_game'] = nfl_df.apply(is_division_game, axis=1)

# Save the updated dataframe to a new CSV file
nfl_df.to_csv('../nfl-2024-UTC-with-div-game.csv', index=False)

# Display the dataframe with the new column
print(nfl_df)