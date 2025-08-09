import { Router } from "express";

import { verifyToken } from "../middlewares/auth.middleware.js";
import {
  createChat,
  gateAllChats,
} from "../controllers/conversation.controller.js";

const router = Router();

router.route("/").get(verifyToken, gateAllChats);
router.route("/").post(verifyToken, createChat);

export default router;
