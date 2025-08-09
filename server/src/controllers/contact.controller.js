import mongoose from "mongoose";
import { Contact } from "../models/contact.model.js";
import { User } from "../models/user.model.js";
import asyncHandler from "../utils/asyncHandler.js";

export const fetchContacts = asyncHandler(async (req, res) => {
  let userId = req.user._id;
  const allContacts = await Contact.aggregate([
    {
      $match: {
        user_id: new mongoose.Types.ObjectId(userId),
      },
    },
    {
      $lookup: {
        from: "users",
        localField: "contact_username",
        foreignField: "username",
        as: "contact_details",
        pipeline: [
          {
            $project: {
              _id: 0,
              email: 1,
            },
          },
        ],
      },
    },
    {
      $sort: {
        createdAt: -1,
      },
    },
  ]);
  if (!allContacts)
    return res.status(500).json({ msg: "Failed to fetch contacts" });

  return res.status(200).json(allContacts);
});

export const newContact = asyncHandler(async (req, res) => {
  const { contact_username } = req.body;
  if (!contact_username)
    return res.status(400).json({ msg: "Username is required" });

  const ExistedContact = await Contact.findOne({
    $and: [{ contact_username: contact_username }, { user_id: req.user._id }],
  });

  const existedUser = await User.findOne({
    username: contact_username,
  });

  if (!existedUser) return res.status(400).json({ msg: "User not found" });

  if (ExistedContact)
    return res
      .status(400)
      .json({ msg: "Contact with this id is already created" });

  await Contact.create({
    user_id: req.user._id,
    contact_username: contact_username,
  });
  return res.status(201).json({ msg: "Contact added" });
});
