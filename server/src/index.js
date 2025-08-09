import express from "express";
import dotenv from "dotenv";
import { connectDb } from "./database/index.js";
import cors from "cors";
import http from "http";
import { Server } from "socket.io";
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(
  cors({
    origin: process.env.CORS_ORIGIN,
    credentials: true,
  })
);
dotenv.config({
  path: "../env",
});

//for socket io
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*", // allow all origins for testing
    methods: ["GET", "POST"],
  },
  transports: ["websocket"],
  allowEIO3: true,
});

//routes
import authRouter from "./routes/auth.route.js";
import conversationRouter from "./routes/conversation.route.js";
import mesageRouter from "./routes/message.route.js";
import contactRouter from "./routes/contact.route.js";
import { sendMessage } from "./controllers/message.controller.js";

app.use("/", authRouter);
app.use("/conversation", conversationRouter);
app.use("/message", mesageRouter);
app.use("/contact", contactRouter);

//connection for socket.io
io.on("connection", (socket) => {
  console.log("A user is connected", socket.id);

  socket.on("joinConversation", (conversationId) => {
    socket.join(conversationId);
    console.log("User joined conversation : " + conversationId);
  });

  socket.on("sendMessage", async (message) => {
    const { conversation_id, sender_id, receiver_id, content } = message;
    try {
      const send_message = await sendMessage(
        conversation_id,
        sender_id,
        receiver_id,
        content
      );
      console.log("Send Message : " + send_message);
      io.to(conversation_id).emit("newMessage", send_message);
      io.emit("conversationUpdated", {
        conversation_id,
        lastMessage: send_message.content,
        lastMessageTime: send_message.updatedAt,
      });
    } catch (error) {
      console.error("Failed to send message : " + error.message);
    }
  });

  socket.on("disconnect", () => {
    console.log("User disconnected : " + socket.id);
  });
});

server.listen(process.env.PORT, () => {
  connectDb();
  console.log("Server running successfully! ", process.env.PORT);
});
