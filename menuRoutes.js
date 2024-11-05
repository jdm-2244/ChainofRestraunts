const express = require('express');
const router = express.Router();

// GET all menu items
router.get('/', async (req, res) => {
  try {
    const result = await req.pool.query('SELECT * FROM MenuItem');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching menu items:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// POST a new menu item
router.post('/', async (req, res) => {
  const { name, category, price } = req.body;
  try {
    const result = await req.pool.query(
      'INSERT INTO MenuItem (name, category, price) VALUES ($1, $2, $3) RETURNING *',
      [name, category, price]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding menu item:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// PUT to update a menu item
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, category, price } = req.body;
  try {
    const result = await req.pool.query(
      'UPDATE MenuItem SET name = $1, category = $2, price = $3 WHERE item_id = $4 RETURNING *',
      [name, category, price, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Menu item not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating menu item:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// DELETE a menu item
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await req.pool.query(
      'DELETE FROM MenuItem WHERE item_id = $1 RETURNING *',
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Menu item not found' });
    }
    res.json({ message: 'Menu item deleted', item: result.rows[0] });
  } catch (error) {
    console.error('Error deleting menu item:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
