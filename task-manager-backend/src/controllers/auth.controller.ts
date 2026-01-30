import bcrypt from "bcrypt";
import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import { prisma } from "../prisma/client";
import { generateAccessToken, generateRefreshToken } from "../utils/jwt";

export const register = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password required" });
  }

  const existingUser = await prisma.user.findUnique({
    where: { email },
  });

  if (existingUser) {
    return res.status(400).json({ message: "User already exists" });
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  await prisma.user.create({
    data: {
      email,
      password: hashedPassword,
    },
  });

  res.status(201).json({ message: "User registered successfully" });
};


export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  const user = await prisma.user.findUnique({
    where: { email },
  });

  if (!user) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const isPasswordValid = await bcrypt.compare(password, user.password);

  if (!isPasswordValid) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const accessToken = generateAccessToken(user.id);
  const refreshToken = generateRefreshToken(user.id);

  res.json({
    accessToken,
    refreshToken,
  });
};


export const refresh = async (req: Request, res: Response) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(401).json({ message: "Refresh token required" });
  }

  try {
    const payload = jwt.verify(
      refreshToken,
      process.env.REFRESH_SECRET!
    ) as { userId: number };

    const newAccessToken = generateAccessToken(payload.userId);

    res.json({ accessToken: newAccessToken });
  } catch {
    res.status(401).json({ message: "Invalid refresh token" });
  }
};

export const logout = async (_req: Request, res: Response) => {
  res.json({ message: "Logged out successfully" });
};
