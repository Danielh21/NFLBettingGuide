// /src/app/api/database.ts

import path from "path";
import sqlite3 from "sqlite3";

const dbFile = process.env.SCHEDULED_FILE_LOCATION ?? "";
export const db = new sqlite3.Database(
  dbFile,
  sqlite3.OPEN_READWRITE | sqlite3.OPEN_CREATE,
  (err) => {
    if (err) {
      console.error(err.message);
    }
  }
);

export const getRows = async (query: string) => {
  return await new Promise((resolve, reject) => {
    db.all(query, (err: Error, row: any) => {
      if (err) {
        console.log(err);
        return reject(err);
      }
      return resolve(row);
    });
  });
};
