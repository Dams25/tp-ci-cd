require("dotenv").config();
const express = require("express");
const path = require("path");

// require the mongoose file
const db = require("./config/mongoose");
const User = require("./models/register");
const Login = require("./models/login");
const Dashboard = require("./models/dashboard");

console.log("Starting server");

const app = express();

// path: routes\index.js
app.use("/", require("./routes/index"));

module.exports = app;
