const express = require('express');
const router = express.Router();

// Get all customers
router.get('/customers', async (req, res) => {
  try {
    const result = await req.pool.query(`
      SELECT user_id, username, email, phone_number, member, 
             "First_name", "Last_name"
      FROM customer
      ORDER BY "Last_name", "First_name"
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching customers:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Get a specific customer by ID with their payment cards
router.get('/customers/:id', async (req, res) => {
  const { id } = req.params;
  try {
    // Get customer details
    const customerResult = await req.pool.query(`
      SELECT user_id, username, email, phone_number, member, 
             "First_name", "Last_name"
      FROM customer 
      WHERE user_id = $1
    `, [id]);

    if (customerResult.rows.length === 0) {
      return res.status(404).json({ error: 'Customer not found' });
    }

    // Get customer's payment cards
    const paymentCardsResult = await req.pool.query(`
      SELECT id, card_num, date_exp, bank 
      FROM payment_cards 
      WHERE user_id = $1
    `, [id]);

    // Get customer's orders
    const ordersResult = await req.pool.query(`
      SELECT o.id, o.order_date, o.total_amount, o.status,
             mi.item_name, f."City" as franchise_city
      FROM orders o
      JOIN menu_item mi ON o."Menu_items_id" = mi.menu_item_id
      JOIN franchise f ON o."Franchise_id" = f.id
      WHERE o.id IN (
        SELECT order_id 
        FROM transactions 
        WHERE cust_id = $1
      )
      ORDER BY o.order_date DESC
    `, [id]);

    // Combine all information
    const customerData = {
      ...customerResult.rows[0],
      payment_cards: paymentCardsResult.rows,
      orders: ordersResult.rows
    };

    res.json(customerData);
  } catch (error) {
    console.error('Error fetching customer details:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Create a new customer
router.post('/customers', async (req, res) => {
  const { username, email, phone_number, member, first_name, last_name } = req.body;
  
  try {
    // Validate email format
    const emailRegex = /^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }

    // Validate phone number format
    const phoneRegex = /^\+?[1-9]\d{1,19}$/;
    if (!phoneRegex.test(phone_number)) {
      return res.status(400).json({ error: 'Invalid phone number format' });
    }

    const result = await req.pool.query(`
      INSERT INTO customer (username, email, phone_number, member, "First_name", "Last_name")
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING user_id, username, email, phone_number, member, "First_name", "Last_name"
    `, [username, email, phone_number, member, first_name, last_name]);

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error creating customer:', error);
    if (error.constraint === 'unique_email') {
      return res.status(400).json({ error: 'Email already exists' });
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Update a customer
router.put('/customers/:id', async (req, res) => {
  const { id } = req.params;
  const { username, email, phone_number, member, first_name, last_name } = req.body;

  try {
    // Validate email format
    const emailRegex = /^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }

    // Validate phone number format
    const phoneRegex = /^\+?[1-9]\d{1,19}$/;
    if (!phoneRegex.test(phone_number)) {
      return res.status(400).json({ error: 'Invalid phone number format' });
    }

    const result = await req.pool.query(`
      UPDATE customer 
      SET username = $1, email = $2, phone_number = $3, 
          member = $4, "First_name" = $5, "Last_name" = $6
      WHERE user_id = $7
      RETURNING user_id, username, email, phone_number, member, "First_name", "Last_name"
    `, [username, email, phone_number, member, first_name, last_name, id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Customer not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating customer:', error);
    if (error.constraint === 'unique_email') {
      return res.status(400).json({ error: 'Email already exists' });
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Delete a customer
router.delete('/customers/:id', async (req, res) => {
  const { id } = req.params;
  
  try {
    const result = await req.pool.query(`
      DELETE FROM customer 
      WHERE user_id = $1
      RETURNING user_id
    `, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Customer not found' });
    }

    res.json({ message: 'Customer deleted successfully' });
  } catch (error) {
    console.error('Error deleting customer:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Add a payment card to a customer
router.post('/customers/:id/payment-cards', async (req, res) => {
  const { id } = req.params;
  const { card_num, date_exp, bank } = req.body;

  try {
    // Validate card number format
    const cardRegex = /^\d{13,19}$/;
    if (!cardRegex.test(card_num)) {
      return res.status(400).json({ error: 'Invalid card number format' });
    }

    const result = await req.pool.query(`
      INSERT INTO payment_cards (card_num, user_id, date_exp, bank)
      VALUES ($1, $2, $3, $4)
      RETURNING id, card_num, date_exp, bank
    `, [card_num, id, date_exp, bank]);

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding payment card:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
