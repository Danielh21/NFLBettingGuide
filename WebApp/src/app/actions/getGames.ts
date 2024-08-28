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
                  nfl_schedule s
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
    "SELECT game_date, week FROM nfl_schedule WHERE  DATE(substr(game_date, 7, 4) || '-' || substr(game_date, 1, 2) || '-' || substr(game_date, 4, 2) || ' ' || substr(game_date, 12, 5)) > DATE('now') ORDER BY  DATE(substr(game_date, 7, 4) || '-' || substr(game_date, 1, 2) || '-' || substr(game_date, 4, 2) || ' ' || substr(game_date, 12, 5)) LIMIT 1;";
  const row = (await getRows(query)) as any;
  return row[0] as NextWeek;
}

export async function GetSingleGame(id: number): Promise<Game> {
  const query = `select * from nfl_schedule where game_id = ${id}`;
  const row = (await getRows(query)) as any;
  return CreateGame(row[0]);
}

export async function GetTendenciesForGame(id: number): Promise<Tendency[]> {
  const query = `select * from tendency t join tendecy_game_map m where m.nfl_schedule_game_id = ${id}`;
  const rows = (await getRows(query)) as any[];
  const tendencyArray: Tendency[] = [];
  rows.forEach((r) => {
    tendencyArray.push(CreateTendency(r));
  });
  return tendencyArray;
}
