import jwt from "jsonwebtoken";

const ACCESS_SECRET = process.env.ACCESS_SECRET || "access-secret";
const REFRESH_SECRET = process.env.REFRESH_SECRET || "refresh-secret";

export const generateAccessToken = (userId: number) =>
  jwt.sign({ userId }, ACCESS_SECRET, { expiresIn: "15m" });

export const generateRefreshToken = (userId: number) =>
  jwt.sign({ userId }, REFRESH_SECRET, { expiresIn: "7d" });
