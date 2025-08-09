import { Router } from "express";
import { verifyToken } from "../middlewares/auth.middleware.js";
import {
  GetAllMessages,
  sendMessage,
} from "../controllers/message.controller.js";

const router = Router();
router.route("/:conversation_id/:receiver_id").post(verifyToken, sendMessage);
router.route("/:conversation_id").get(verifyToken, GetAllMessages);

export default router;
