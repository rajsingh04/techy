import mongoose, { Schema } from "mongoose";

const chatSchema = new mongoose.Schema(
  {
    participant_one: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    participant_two: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

export const Chat = mongoose.model("Chat", chatSchema);
