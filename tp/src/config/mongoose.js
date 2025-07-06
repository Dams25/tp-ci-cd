// require mongoose
const mongoose = require("mongoose");
// connect to database
const mongoUri = process.env.MONGODB_URI || process.env.MONGODB_URL || 'mongodb://localhost:27017/todolist';
mongoose.connect(mongoUri);

// acquire the connection (to check if it is successful)
const db = mongoose.connection;
// check for error
db.on("error", console.error.bind(console, "connection error:"));
// once connection is open, log to console
db.once("open", function () {
  console.log("connected to database");
});

module.exports = db;
