"use server";
import sqlite3 from "sqlite3";
import path from "path";
import { getRows } from "./database";
import { Game } from "../models/Game";
import { CreateGame } from "../factories/GameFactory";
import { NextWeek } from "../models/NextWeek";

export async function GetGames(weekNo: number): Promise<Game[]> {
  const query = `select * from nfl_schedule where week = ${weekNo}`;
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
