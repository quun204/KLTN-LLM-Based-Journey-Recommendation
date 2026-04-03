import sql from "mssql";

import { env } from "./env.js";

let poolPromise: Promise<sql.ConnectionPool> | null = null;

export async function getDbPool(): Promise<sql.ConnectionPool> {
  if (!poolPromise) {
    poolPromise = sql.connect({
      server: env.db.server,
      port: env.db.port,
      database: env.db.database,
      user: env.db.user,
      password: env.db.password,
      options: env.db.options
    });
  }

  return poolPromise;
}