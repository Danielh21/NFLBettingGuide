import { Tendency } from "./Tendecy";

export interface Game {
  game_id: string;
  week: number;
  home_team: string;
  away_team: string;
  spread_line: number;
  div_game: boolean;
  numberOfTendencies?: number;
  tendencies?: Tendency[];
}
