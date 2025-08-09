import { Router } from "express";
import { verifyToken } from "../middlewares/auth.middleware.js";
import {
  fetchContacts,
  newContact,
} from "../controllers/contact.controller.js";

const router = Router();

router.route("/").post(verifyToken, newContact).get(verifyToken, fetchContacts);

export default router;
