import mongoose from "mongoose";
import { Chat } from "../models/chat.model.js";

import asyncHandler from "../utils/asyncHandler.js";

export const gateAllChats = asyncHandler(async (req, res) => {
  const allChats = await Chat.aggregate([
    {
      $match: {
        $or: [
          { participant_one: new mongoose.Types.ObjectId(req.user._id) },
          { participant_two: new mongoose.Types.ObjectId(req.user._id) },
        ],
      },
    },
    {
      $lookup: {
        from: "users",
        localField: "participant_two",
        foreignField: "_id",
        as: "participant_name",
        pipeline: [
          {
            $project: {
              username: 1,
            },
          },
        ],
      },
    },
    {
      $lookup: {
        from: "messages",
        let: {
          conversationId: "$_id",
        },
        pipeline: [
          {
            $match: {
              $expr: {
                $eq: ["$conversation_id", "$$conversationId"],
              },
            },
          },
          {
            $sort: {
              updatedAt: -1,
            },
          },
          {
            $limit: 1,
          },
          {
            $project: {
              content: 1,
              updatedAt: 1,
              sender_id: 1,
              receiver_id: 1,
            },
          },
        ],
        as: "lastMessage",
      },
    },
  ]);
  console.log(req.user._id);

  return res.status(200).json(allChats);
});

export const createChat = asyncHandler(async (req, res) => {
  const { participant_two } = req.body;

  const oldChat = await Chat.findOne({
    $and: [
      { participant_one: req.user._id },
      {
        participant_two: participant_two,
      },
    ],
  });
  const oldChat2 = await Chat.findOne({
    $and: [
      { participant_one: participant_two },
      {
        participant_two: req.user._id,
      },
    ],
  });

  if (oldChat || oldChat2)
    return res.status(400).json({ msg: "chat is already created" });

  const newChat = await Chat.create({
    participant_one: req.user._id,
    participant_two: participant_two,
  });

  if (!newChat) return res.status(400).json({ msg: "Please try again later" });

  return res.status(201).json(newChat);
});
