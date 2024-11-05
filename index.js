require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const path = require('path');

// Import menu routes
const menuRoutes = require('./menuRoutes');

// Initialize the Express app
const app = express();
const port = process.env.PORT || 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Initialize the database pool connection using DATABASE_URL from .env
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Check database connection
pool.connect((err) => {
  if (err) {
    console.error('Connection error', err.stack);
  } else {
    console.log('Connected to the database');
  }
});

// Middleware to attach pool to every request
app.use((req, res, next) => {
  req.pool = pool;
  next();
});

// Route to serve the homepage
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'homepage.html'));
});

// Use menu routes for /api/menu paths
app.use('/api/menu', menuRoutes);

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
