import { User } from "../models/user.model.js";
import asyncHandler from "../utils/asyncHandler.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const SALT = 6;
const JWT_SECRET = process.env.JWT_SECRET || "techysecretkey";

export const registerUser = asyncHandler(async (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password)
    return res.status(400).json({ msg: "All fields are required" });

  const hashedPasword = await bcrypt.hash(password, SALT);

  const existedUser = await User.findOne({
    $or: [{ username }, { email }],
  });
  if (existedUser)
    return res
      .status(400)
      .json({ msg: "user with this username or email is already exists" });
  const user = await User.create({
    username,
    email,
    password: hashedPasword,
  });
  if (!user)
    return res.status(400).json({ msg: "Problem while creating new user" });
  return res.status(201).json(user);
});

export const loginUser = asyncHandler(async (req, res) => {
  const { username, password } = req.body;
  const loggedInUser = await User.findOne({
    username,
  });
  if (!loggedInUser) return res.status(400).json({ msg: "User not found" });
  const isMatch = await bcrypt.compare(password, loggedInUser.password);
  if (!isMatch) return res.status(400).json({ msg: "Invalid credentials" });

  const token = jwt.sign({ id: loggedInUser._id }, JWT_SECRET, {
    expiresIn: "30d",
  });

  const user = await User.findById(loggedInUser._id).select("-password ");
  user.token = token;
  await user.save();
  return res.status(200).json(user);
});
