import { Request, Response } from "express";
import { prisma } from "../prisma/client";

export const createTask = async (req: Request, res: Response) => {
  const { title } = req.body;

  if (!title) {
    return res.status(400).json({ message: "Title required" });
  }

  const task = await prisma.task.create({
    data: {
      title,
      userId: req.userId!,
    },
  });

  res.status(201).json(task);
};


export const getTasks = async (req: Request, res: Response) => {
  const { page = "1", status, search } = req.query;

  const tasks = await prisma.task.findMany({
    where: {
      userId: req.userId!,
      status:
        status !== undefined ? status === "true" : undefined,
      title: search
        ? { contains: String(search),}
        : undefined,
    },
    skip: (Number(page) - 1) * 10,
    take: 10,
  });

  res.json(tasks);
};


export const getTaskById = async (req: Request, res: Response) => {
  const task = await prisma.task.findUnique({
    where: { id: Number(req.params.id) },
  });

  if (!task || task.userId !== req.userId) {
    return res.status(404).json({ message: "Task not found" });
  }

  res.json(task);
};


export const updateTask = async (req: Request, res: Response) => {
  const task = await prisma.task.findUnique({
    where: { id: Number(req.params.id) },
  });

  if (!task || task.userId !== req.userId) {
    return res.status(404).json({ message: "Task not found" });
  }

  const updated = await prisma.task.update({
    where: { id: task.id },
    data: req.body,
  });

  res.json(updated);
};


export const deleteTask = async (req: Request, res: Response) => {
  const task = await prisma.task.findUnique({
    where: { id: Number(req.params.id) },
  });

  if (!task || task.userId !== req.userId) {
    return res.status(404).json({ message: "Task not found" });
  }

  await prisma.task.delete({ where: { id: task.id } });

  res.status(204).send();
};


export const toggleTask = async (req: Request, res: Response) => {
  const task = await prisma.task.findUnique({
    where: { id: Number(req.params.id) },
  });

  if (!task || task.userId !== req.userId) {
    return res.status(404).json({ message: "Task not found" });
  }

  const updated = await prisma.task.update({
    where: { id: task.id },
    data: { status: !task.status },
  });

  res.json(updated);
};
