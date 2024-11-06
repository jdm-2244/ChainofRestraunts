const express = require('express');
const router = express.Router();

// GET all menu items
router.get('/menu-items', async (req, res) => {
  try {
    const result = await req.pool.query('SELECT * FROM menu_item');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching menu items:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// POST a new menu item
router.post('/menu-items', async (req, res) => {
  const { item_name, type_of_menu_item, price } = req.body;
  try {
    const result = await req.pool.query(
      'INSERT INTO menu_item (item_name, type_of_menu_item, price) VALUES ($1, $2, $3) RETURNING *',
      [item_name, type_of_menu_item, price]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding menu item:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// PUT to update a menu item
router.put('/menu-items/:id', async (req, res) => {
  const { id } = req.params;
  const { item_name, type_of_menu_item, price } = req.body;
  try {
    const result = await req.pool.query(
      'UPDATE menu_item SET item_name = $1, type_of_menu_item = $2, price = $3 WHERE menu_item_id = $4 RETURNING *',
      [item_name, type_of_menu_item, price, id]
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
router.delete('/menu-items/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await req.pool.query(
      'DELETE FROM menu_item WHERE menu_item_id = $1 RETURNING *',
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
