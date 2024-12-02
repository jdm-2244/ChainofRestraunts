require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const path = require('path');

// Import routes
const menuRoutes = require('./menuRoutes');
const customerRoutes = require('./customerRoutes');

const app = express();
const port = process.env.PORT || 3000;

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Attach the pool to the request object for use in routes
app.use((req, res, next) => {
  req.pool = pool;
  next();
});

// Middleware for JSON parsing
app.use(express.json());

// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));

// Route handlers
app.use('/api/menu', menuRoutes);
app.use('/api/customers', customerRoutes);

// Static routes for frontend files
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'homepage.html'));
});
app.get('/dashboard.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard.html'));
});
app.get('/menu-items.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'menu-items.html'));
});
app.get('/transactions.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'transactions.html'));
});
app.get('/customers.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'customers.html'));
});

// API Routes

// Fetch all customers
app.get('/api/customers', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT user_id, username, email, phone_number, member, "First_name", "Last_name"
      FROM customer
      ORDER BY "Last_name", "First_name"
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching customer details:', error);
    res.status(500).json({ error: 'Failed to fetch customer details' });
  }
});

// Add a new transaction
app.post('/api/transaction', async (req, res) => {
  const { cust_id, payment_id, cash, amount, order_id } = req.body;
  try {
    await pool.query('BEGIN');

    // Create transaction record
    await pool.query(
      `INSERT INTO transactions (payment_id, cash, amount, order_id, cust_id) 
       VALUES ($1, $2, $3, $4, $5)`,
      [payment_id, cash, amount, order_id, cust_id]
    );

    // Update order status
    await pool.query(
      `UPDATE orders SET status = 'completed' WHERE id = $1`,
      [order_id]
    );

    await pool.query('COMMIT');
    res.status(201).json({ message: 'Transaction completed successfully' });
  } catch (error) {
    await pool.query('ROLLBACK');
    console.error('Transaction error:', error);
    res.status(500).json({ error: 'Transaction failed', details: error.message });
  }
});

// Fetch all transactions
app.get('/api/transactions', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT t.transaction_id, t.payment_id, t.cash, t.amount, t.order_id, t.cust_id,
             t.created_at, c.username, c.email
      FROM transactions t
      JOIN customer c ON c.user_id = t.cust_id
      ORDER BY t.created_at DESC
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({ error: 'Failed to fetch transactions' });
  }
});

// Fetch all orders
app.get('/api/orders', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT o.id as order_id, o.order_date, o.total_amount, o.status,
             f."City" as franchise_city, f."State" as franchise_state
      FROM orders o
      JOIN franchise f ON o."Franchise_id" = f.id
      ORDER BY o.order_date DESC
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
});

// Fetch menu items with prices
app.get('/api/menu-items', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT mi.menu_item_id, mi.item_name, mi.type_of_menu_item, 
             mi.quantity, p.price
      FROM menu_item mi
      JOIN pricing p ON mi.menu_item_id = p.menu_item_id
      ORDER BY mi.type_of_menu_item, mi.item_name
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching menu items:', error);
    res.status(500).json({ error: 'Failed to fetch menu items' });
  }
});

// Create a new order
app.post('/api/orders', async (req, res) => {
  const { customer_id, franchise_id, menu_items, total_amount } = req.body;

  if (!customer_id || !franchise_id || !menu_items || !total_amount) {
    return res.status(400).json({ error: 'Missing required fields: customer_id, franchise_id, menu_items, or total_amount' });
  }

  try {
    await pool.query('BEGIN');

    // Insert new order
    const orderResult = await pool.query(
      `INSERT INTO orders ("Franchise_id", total_amount, status, order_date)
       VALUES ($1, $2, 'pending', NOW()) RETURNING id`,
      [franchise_id, total_amount]
    );
    const orderId = orderResult.rows[0].id;

    // Link menu items to the order
    for (const menuItemId of menu_items) {
      await pool.query(
        `INSERT INTO order_items (order_id, menu_item_id)
         VALUES ($1, $2)`,
        [orderId, menuItemId]
      );
    }

    // Insert a transaction for this order
    await pool.query(
      `INSERT INTO transactions (order_id, cust_id, amount, cash, created_at)
       VALUES ($1, $2, $3, $4, NOW())`,
      [orderId, customer_id, total_amount, true] // assuming cash transaction
    );

    await pool.query('COMMIT');
    res.status(201).json({ message: 'Order created successfully', orderId });
  } catch (error) {
    await pool.query('ROLLBACK');
    console.error('Error creating order:', error);
    res.status(500).json({ error: 'Failed to create order' });
  }
});

// Fetch menu categories
app.get('/api/menu-categories', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT DISTINCT type_of_menu_item
      FROM menu_item
      ORDER BY type_of_menu_item
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching menu categories:', error);
    res.status(500).json({ error: 'Failed to fetch menu categories' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
