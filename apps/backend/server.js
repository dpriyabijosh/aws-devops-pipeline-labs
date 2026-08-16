const express = require("express");
const { Client } = require("pg");
const promClient = require("prom-client");

const app = express();
const port = 4000;

const dbClient = new Client({
  user: "postgres",
  host: "db",
  database: "appdb",
  password: "postgres",
  port: 5432
});

dbClient.connect()
  .then(() => console.log("PostgreSQL connected"))
  .catch(err => console.error("PostgreSQL connection error:", err));

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get("/api/status", async (req, res) => {
  try {
    const result = await dbClient.query("SELECT NOW()");
    res.json({
      app: "log-parser-backend",
      status: "healthy",
      timestamp: new Date().toISOString(),
      databaseTime: result.rows[0].now
    });
  } catch (error) {
    res.status(500).json({ error: "Database query failed" });
  }
});

app.get("/api/logs", async (req, res) => {
  try {
    const result = await dbClient.query("SELECT * FROM log_events");
    res.json({
      totalErrors: result.rowCount,
      incidents: result.rows
    });
  } catch (error) {
    res.status(500).json({ error: "Could not fetch logs" });
  }
});

promClient.collectDefaultMetrics({ timeout: 5000 });

app.get("/metrics", async (req, res) => {
  try {
    const metrics = await promClient.register.metrics();
    res.set("Content-Type", promClient.register.contentType);
    res.end(metrics);
  } catch (error) {
    console.error("Metrics generation failed:", error);
    res.status(500).send("Error generating metrics");
  }
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});