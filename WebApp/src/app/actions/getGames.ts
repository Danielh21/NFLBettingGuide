"use server";
import sqlite3 from "sqlite3";
import path from "path";
import { getRows } from "./database";
import { Game } from "../models/Game";
import { CreateGame } from "../factories/GameFactory";

export async function GetGames(): Promise<Game[]> {
  const query = "select * from nfl_schedule where week = 1";
  const rows = (await getRows(query)) as any[];
  const gameArray: Game[] = [];
  rows.forEach((r) => {
    gameArray.push(CreateGame(r));
  });
  return gameArray;
}
