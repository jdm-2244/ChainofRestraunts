// franchiseRoutes.js
const express = require('express');
const router = express.Router();

// Get all franchises
router.get('/', async (req, res) => {
    try {
        const query = `
            SELECT
                "City",
                "State",
                address,
                zip
            FROM franchise
            ORDER BY "City"
        `;
        const result = await req.pool.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching franchises:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get a specific franchise by ID
router.get('/:id', async (req, res) => {
    try {
        const query = `
            SELECT
                "City",
                "State",
                address,
                zip
            FROM franchise
            WHERE id = $1
        `;
        const result = await req.pool.query(query, [req.params.id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Franchise not found' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error('Error fetching franchise:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;