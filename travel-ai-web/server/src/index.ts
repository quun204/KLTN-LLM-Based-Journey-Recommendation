import { createApp } from "./app.js";
import { connectMongoDB } from "./config/database.js";
import { env } from "./config/env.js";

async function start() {
  try {
    await connectMongoDB();
    console.log("✓ Database initialized");
  } catch (error) {
    console.error("✗ Failed to connect to database:", error);
    process.exit(1);
  }

  const app = createApp();

  app.listen(env.port, () => {
    console.log(`Travel AI server listening on http://localhost:${env.port}`);
  });
}

start();