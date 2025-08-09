import mongoose, { isValidObjectId } from "mongoose";
import { Chat } from "../models/chat.model.js";
import { Message } from "../models/message.model.js";
import { User } from "../models/user.model.js";
import asyncHandler from "../utils/asyncHandler.js";

export const sendMessage = async (
  conversation_id,
  sender_id,
  receiver_id,
  content
) => {
  try {
    if (!isValidObjectId(conversation_id) || !isValidObjectId(receiver_id))
      return "Invalid id";
    if (!content) return "Field can't be null";

    const user = await User.findById(receiver_id);
    const chat = await Chat.findById(conversation_id);
    if (!user) {
      return "User not found for chatting";
    }

    if (!chat) {
      const oldChat = await Chat.findOne({
        $and: [
          { participant_one: sender_id },
          {
            participant_two: receiver_id,
          },
        ],
      });
      const oldChat2 = await Chat.findOne({
        $and: [
          { participant_one: receiver_id },
          {
            participant_two: sender_id,
          },
        ],
      });

      if (oldChat || oldChat2) return "chat is already created";
      else {
        await Chat.create({
          participant_one: sender_id,
          participant_two: user._id,
        });
      }
    }

    const newMessage = await Message.create({
      sender_id: sender_id,
      receiver_id: receiver_id,
      conversation_id: conversation_id,
      content: content,
    });

    if (!newMessage) return "Problem while sending messsage";

    return newMessage;
  } catch (error) {
    return error;
  }
};

export const GetAllMessages = asyncHandler(async (req, res) => {
  const { conversation_id } = req.params;
  if (!isValidObjectId(conversation_id)) {
    return res.status(400).json({ msg: "Invalid chat id" });
  }
  const allMessagesOfUser = await Message.aggregate([
    {
      $match: {
        conversation_id: new mongoose.Types.ObjectId(conversation_id),
      },
    },
    {
      $sort: {
        createdAt: 1,
      },
    },
  ]);
  if (!allMessagesOfUser)
    return res.status(400).json({ msg: "Problem while fetching messages" });
  return res.status(200).json(allMessagesOfUser);
});
