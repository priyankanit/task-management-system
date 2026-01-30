import cors from "cors";
import express from "express";
import authRoutes from "./routes/auth.routes";
import taskRoutes from "./routes/task.routes";

const app = express();

app.use(cors());
app.use(express.json());
app.use("/auth", authRoutes);
app.use("/tasks", taskRoutes);

// Health check
app.get("/", (_req, res) => {
  res.send("Task Manager API running");
});

export default app;
