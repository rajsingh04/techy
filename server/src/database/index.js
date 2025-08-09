import mongoose from "mongoose";
import { DB_NAME } from "../utils/constant.js";

export const connectDb = async () => {
  try {
    const response = await mongoose.connect(
      `${process.env.MONGO_URL}/${DB_NAME}`
    );
    console.log("DATABASE CONNECTED!", response.connection.host);
  } catch (e) {
    console.log(e.message);
  }
};
