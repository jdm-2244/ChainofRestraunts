require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

// Initialize the database pool connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.connect((err) => {
  if (err) {
    console.error('Connection error', err.stack);
  } else {
    console.log('Connected to the database');
  }
});

// Simple route to confirm server is running
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/homepage.html');
  });

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
