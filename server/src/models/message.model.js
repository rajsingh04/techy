import mongoose, { Schema } from "mongoose";

const messageSchema = new mongoose.Schema(
  {
    conversation_id: {
      type: Schema.Types.ObjectId,
      ref: "Chat",
      required: true,
    },
    sender_id: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    receiver_id: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    content: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);
export const Message = mongoose.model("Message", messageSchema);
