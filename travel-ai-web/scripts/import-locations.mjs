import mongoose from "mongoose";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";
import dotenv from "dotenv";

dotenv.config();

const __dirname = path.dirname(fileURLToPath(
    import.meta.url));
const MONGO_URI = process.env.MONGO_URI || "mongodb+srv://phananhtuan302_db_user:123z456z@dbtourist.vfkdtpu.mongodb.net/?appName=DBtourist";
const DB_NAME = "DBWebsite";
const COLLECTION_NAME = "diadiem";

async function importLocations() {
    try {
        console.log("🔗 Connecting to MongoDB...");
        const conn = await mongoose.connect(MONGO_URI, {
            serverSelectionTimeoutMS: 10000,
            connectTimeoutMS: 10000,
            dbName: DB_NAME
        });

        const db = conn.connection.db;
        console.log(`✓ Connected to database: ${DB_NAME}`);

        // Read mock locations data
        console.log("📖 Reading mock locations data...");
        const dataPath = path.join(__dirname, "../dist-server/data/mock-locations.json");
        const jsonData = await fs.readFile(dataPath, "utf-8");
        const locations = JSON.parse(jsonData);
        console.log(`✓ Found ${locations.length} locations to import`);

        // Drop existing collection
        const collection = db.collection(COLLECTION_NAME);
        try {
            await collection.drop();
            console.log(`✓ Dropped existing collection: ${COLLECTION_NAME}`);
        } catch (err) {
            if (err.code !== 26) {
                // 26 = namespace does not exist
                throw err;
            }
            console.log(`✓ Collection ${COLLECTION_NAME} does not exist, creating new one`);
        }

        // Insert locations
        const result = await collection.insertMany(locations);
        console.log(`✓ Successfully imported ${result.insertedCount} locations!`);

        // Create indexes
        await collection.createIndex({ id: 1 });
        await collection.createIndex({ categoryCode: 1 });
        await collection.createIndex({ featured: 1 });
        await collection.createIndex({ rating: -1 });
        await collection.createIndex({ name: "text", address: "text" });
        console.log(`✓ Created database indexes`);

        // Show summary
        const count = await collection.countDocuments();
        console.log(`\n📊 Summary:`);
        console.log(`   Database: ${DB_NAME}`);
        console.log(`   Collection: ${COLLECTION_NAME}`);
        console.log(`   Total documents: ${count}`);

        await mongoose.disconnect();
        console.log("\n✅ Import completed successfully!");
    } catch (error) {
        console.error("❌ Import failed:", error.message);
        process.exit(1);
    }
}

importLocations();