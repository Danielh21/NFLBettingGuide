"use server";
import sqlite3 from "sqlite3";
import path from "path";
import { getRows } from "./database";
import { Game } from "../models/Game";
import { CreateGame } from "../factories/GameFactory";
import { NextWeek } from "../models/NextWeek";
import { Tendency } from "../models/Tendecy";
import { CreateTendency } from "../factories/TendencyFactory";

export async function GetGames(weekNo: number): Promise<Game[]> {
  const query = `SELECT 
                  s.*, 
                  COUNT(m.nfl_schedule_game_id) AS numberOfTendencies
                FROM 
                  nfl_schedule_2024 s
                LEFT JOIN 
                  tendecy_game_map m ON s.game_id = m.nfl_schedule_game_id
                WHERE 
                  s.week = ${weekNo}
                GROUP BY 
                  s.game_id;
                `;
  // const query = `select * from nfl_schedule where week = ${weekNo}`;
  const rows = (await getRows(query)) as any[];
  const gameArray: Game[] = [];
  rows.forEach((r) => {
    gameArray.push(CreateGame(r));
  });
  return gameArray;
}

export async function GetNextWeek(): Promise<NextWeek> {
  const query =
    "SELECT MIN(gameday) AS game_day, week FROM nfl_schedule_2024 WHERE gameday > DATE('now') LIMIT 1;";
  const row = (await getRows(query)) as any;
  return row[0] as NextWeek;
}

export async function GetSingleGame(id: string): Promise<Game> {
  const query = `select * from nfl_schedule_2024 where game_id = '${id}'`;
  const row = (await getRows(query)) as any;
  return CreateGame(row[0]);
}

export async function GetTendenciesForGame(id: string): Promise<Tendency[]> {
  const query = `SELECT * 
                FROM tendency t 
                JOIN tendecy_game_map m on m.tendecy_id = t.id
                WHERE m.nfl_schedule_game_id = '${id}';`;
  const rows = (await getRows(query)) as any[];
  const tendencyArray: Tendency[] = [];
  rows.forEach((r) => {
    tendencyArray.push(CreateTendency(r));
  });
  return tendencyArray;
}
