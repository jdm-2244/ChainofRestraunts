const express = require('express');
const router = express.Router();

// GET all customers
router.get('/customers', async (req, res) => {
  try {
    const result = await req.pool.query('SELECT * FROM "Customer"');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching customers:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// GET a specific customer by ID
router.get('/customers/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await req.pool.query('SELECT * FROM "Customer" WHERE user_id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Customer not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching customer:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
