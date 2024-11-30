require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const menuRoutes = require('./menuRoutes');

const app = express();
const port = process.env.PORT || 3000;

// Database connection 
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});


app.use((req, res, next) => {
  req.pool = pool;
  next();
});


app.use(express.json());
// Add this line to serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')));
//homepage
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'homepage.html'));
});

// Use menu routes 
app.use('/api/menu', menuRoutes);

// Customer details 
app.get('/api/customers', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT user_id, username, email, phone_number, member, "First_name", "Last_name"
      FROM "Customer"
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching customer details:', error);
    res.status(500).json({ error: 'Failed to fetch customer details' });
  }
});

// POST route for creating a new transaction
app.post('/api/transaction', async (req, res) => {
  const { cust_id, card_id, amount, order_id } = req.body;
  try {
    await pool.query('BEGIN'); // Start the transaction

    const cardUpdate = await pool.query(
      `UPDATE "Payment_cards" SET balance = balance - $1 WHERE id = $2 AND user_id = $3 RETURNING balance`,
      [amount, card_id, cust_id]
    );

    if (cardUpdate.rowCount === 0) {
      throw new Error('Card not found or insufficient funds');
    }

    const paymentResult = await pool.query(
      `INSERT INTO "Payments" (card_id, amount, cust_id) VALUES ($1, $2, $3) RETURNING payment_id`,
      [card_id, amount, cust_id]
    );

    const paymentId = paymentResult.rows[0].payment_id;

    await pool.query(
      `INSERT INTO "Transactions" ("Payment_id", "Cash", "Amount", "Order_id", cust_id) 
      VALUES ($1, false, $2, $3, $4)`,
      [paymentId, amount, order_id, cust_id]
    );

    await pool.query('COMMIT'); // Commit the transaction
    res.status(201).json({ message: 'Transaction completed successfully' });
  } catch (error) {
    await pool.query('ROLLBACK'); // Rollback on error
    console.error('Transaction error:', error.message);
    res.status(500).json({ error: 'Transaction failed', details: error.message });
  }
});

// GET route for fetching all transactions
app.get('/api/transactions', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT t.transaction_id, t."Payment_id", t."Cash", t."Amount", t."Order_id", t.cust_id,
             c.username, c.email, o."Franchise_id"
      FROM "Transactions" t
      JOIN "Customer" c ON c.user_id = t.cust_id
      JOIN "Orders" o ON o.id = t."Order_id"
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({ error: 'Failed to fetch transactions' });
  }
});

// GET route for viewing all orders with customer and franchise information
app.get('/api/orders', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT o.id as order_id, c.username, c.email, f."City" as franchise_city
      FROM "Orders" o
      JOIN "Customer" c ON c.user_id = o.cust_id
      JOIN "Franchise" f ON o."Franchise_id" = f.id
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
});

// GET route for summarizing payments by franchise
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

// GET route for listing menu items and their prices by type
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


app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
