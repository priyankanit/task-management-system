import { Router } from "express";
import {
    createTask,
    deleteTask,
    getTaskById,
    getTasks,
    toggleTask,
    updateTask,
} from "../controllers/task.controller";
import { authenticate } from "../middleware/auth.middleware";

const router = Router();

router.use(authenticate);

router.post("/", createTask);
router.get("/", getTasks);
router.get("/:id", getTaskById);
router.patch("/:id", updateTask);
router.delete("/:id", deleteTask);
router.patch("/:id/toggle", toggleTask);

export default router;
