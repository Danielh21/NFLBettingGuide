import { Game } from "../models/Game";

export function CreateGame(game: any): Game {
  return {
    game_id: game.game_id.toString(), // Ensure game_id is a string
    week: game.week,
    home_team: game.home_team,
    away_team: game.away_team,
    spread_line: game.spread_line,
    div_game: Boolean(game.div_game), // Convert to boolean,
    numberOfTendencies: game.numberOfTendencies,
  };
}
