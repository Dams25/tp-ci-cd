const express = require("express");
const router = express.Router();
const homeController = require("../controllers/homeController");
const dashboardController = require("../controllers/dashboardController");
const registerController = require("../controllers/registerController");
const completedtaskController = require("../controllers/completedtaskController");
const Task = require("../models/task");
const TaskController = require("../controllers/TaskController");

// path: routes\index.js
console.log("Router loaded");
const taskController = new TaskController(Task);

// Health check endpoint pour Docker monitoring
router.get("/health", (req, res) => {
  const healthCheck = {
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || "development",
    version: process.env.npm_package_version || "1.0.0",
    memory: process.memoryUsage(),
    pid: process.pid
  };
  
  try {
    // Test de connexion à MongoDB (simple ping)
    const mongoose = require("mongoose");
    if (mongoose.connection.readyState === 1) {
      healthCheck.database = "connected";
    } else {
      healthCheck.database = "disconnected";
      healthCheck.status = "DEGRADED";
    }
  } catch (error) {
    healthCheck.database = "error";
    healthCheck.status = "ERROR";
    healthCheck.error = error.message;
  }
  
  const statusCode = healthCheck.status === "OK" ? 200 : 503;
  res.status(statusCode).json(healthCheck);
});

//router.get("/", homeController.home);
router.get("/dashboard", dashboardController.dashboard);
router.get("/register", registerController.register);
router.get("/tasks", taskController.all.bind(taskController));
//router.put("/tasks/:id", taskController.update.bind(taskController));
router.get("/completedtask", completedtaskController.completedtask);

// Route de base temporaire pour tester
router.get("/", (req, res) => {
  res.json({
    message: "TodoList API is running",
    status: "OK",
    endpoints: {
      health: "/health",
      tasks: "/tasks", 
      dashboard: "/dashboard",
      register: "/register",
      completedtask: "/completedtask"
    },
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
