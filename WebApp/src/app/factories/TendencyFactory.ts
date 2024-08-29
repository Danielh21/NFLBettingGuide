import { Tendency } from "../models/Tendecy";

export function CreateTendency(row: any): Tendency {
  return {
    id: row.id,
    games_included: row.games_included,
    tendecyName: row.tendecyName,
    text_describtion: row.text_describtion,
    analysis_team_not_cover: row.analysis_team_not_cover,
    analyis_team_cover: row.analyis_team_cover,
    pushes: row.pushes,
    analyis_team_is_home_team: row.analyis_team_is_home_team,
  };
}
