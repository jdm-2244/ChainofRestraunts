require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const path = require('path');

// Import menu routes
const menuRoutes = require('./menuRoutes');

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

// Sample Transaction: Deduct payment from a customer's card and log the transaction
app.post('/api/transaction', async (req, res) => {
  const { cust_id, card_id, amount, order_id } = req.body;
  try {
    await pool.query('BEGIN');
    
    // Deduct the amount from the customer's card balance
    await pool.query(
      `UPDATE "Payment_cards" SET balance = balance - $1 WHERE id = $2 AND user_id = $3`,
      [amount, card_id, cust_id]
    );

    // Insert the transaction into Payments
    const result = await pool.query(
      `INSERT INTO "Payments" (card_id, amount, cust_id) VALUES ($1, $2, $3) RETURNING *`,
      [card_id, amount, cust_id]
    );

    // Insert into Transactions table
    await pool.query(
      `INSERT INTO "Transactions" ("Payment_id", "Cash", "Amount", "Order_id", cust_id) 
      VALUES ($1, false, $2, $3, $4)`,
      [result.rows[0].payment_id, amount, order_id, cust_id]
    );

    await pool.query('COMMIT');
    res.status(201).json({ message: 'Transaction completed successfully' });
  } catch (error) {
    await pool.query('ROLLBACK');
    console.error('Transaction error:', error);
    res.status(500).json({ error: 'Transaction failed' });
  }
});

// Insightful Queries using Joins

// Query 1: View all orders with customer information
app.get('/api/orders', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT o.id as order_id, c.username, c.email, f."City" as franchise_city
      FROM "Orders" o
      JOIN "Customer" c ON o.customer_id = c.user_id
      JOIN "Franchise" f ON o."Franchise_id" = f.id
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
});

// Query 2: Summarize payments by franchise
app.get('/api/payments-summary', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT f."City", SUM(p.amount) AS total_payments
      FROM "Payments" p
      JOIN "Orders" o ON o.id = p.order_id
      JOIN "Franchise" f ON o."Franchise_id" = f.id
      GROUP BY f."City"
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching payments summary:', error);
    res.status(500).json({ error: 'Failed to fetch payments summary' });
  }
});

// Query 3: List menu items and their prices by type
app.get('/api/menu-items', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT mi.item_name, mi.type_of_menu_item, p.price
      FROM menu_item mi
      JOIN "Pricing" p ON mi.menu_item_id = p.menu_item_id
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching menu items:', error);
    res.status(500).json({ error: 'Failed to fetch menu items' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
