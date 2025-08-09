import { User } from "../models/user.model.js";
import asyncHandler from "../utils/asyncHandler.js";
import jwt from "jsonwebtoken";

export const verifyToken = asyncHandler(async (req, res, next) => {
  const token = req.header("Authorization")?.replace("Bearer", "");
  if (!token) {
    return res.status(403).json({ error: "No token provided" });
  }
  const decodedToken = jwt.verify(
    token,
    process.env.JWT_SECRET || "techysecretkey"
  );
  const user = await User.findById(decodedToken?.id);
  if (!user) return res.status(401).json({ msg: "invalid token" });
  req.user = user;
  next();
});
