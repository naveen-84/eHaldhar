const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const bcrypt = require("bcrypt");

const app = express();
app.use(express.json());
app.use(cors());

mongoose
  .connect(
    "mongodb+srv://sharmanaveens983:8425@cluster0.kccsf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0", // Replace with your MongoDB connection string
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(() => console.log("MongoDB connected successfully"))
  .catch((err) => console.error("MongoDB connection error:", err));

// Define User Schema
const UserSchema = new mongoose.Schema({
  name: String,
  mobile: String,
  email: String,
  password: String,
  category: String,
});

const User = mongoose.model("User", UserSchema);

// GET route for testing signup endpoint
app.get("/signup", (req, res) => {
  res.send("Signup route is working!");
});

// POST route for user registration
app.post("/signup", async (req, res) => {
  try {
    const { name, mobile, email, password, category } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ mobile });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists!" });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = new User({
      name,
      mobile,
      email,
      password: hashedPassword,
      category,
    });

    // Save the new user to the database
    await newUser.save();
    res.status(201).json({ message: "User registered successfully!" });
  } catch (error) {
    console.error("Signup Error:", error);
    res.status(500).json({ message: "Server error" });
  }
});

// Start the server
app.listen(5000, () => {
  console.log("Server running on port 5000");
});
