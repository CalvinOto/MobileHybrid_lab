const db = require('../db');

const buyResource = async (req, res) => {
  const { resource_id, quantity } = req.body;
  const user_id = req.user.id;

  if (!resource_id || !quantity || quantity < 1) {
    return res.status(400).json({ message: 'Resource ID and valid quantity are required' });
  }

  try {
    // 1. Check if the resource exists
    const [rows] = await db.query('SELECT * FROM resources WHERE id = ?', [resource_id]);
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Resource not found' });
    }

    const resource = rows[0];
    
    // 2. Verify stock
    if (resource.stock < quantity) {
      return res.status(400).json({ message: 'Insufficient stock' });
    }

    const total_price = resource.price * quantity;

    // 3. Record the purchase
    await db.query(
      'INSERT INTO purchases (user_id, resource_id, quantity, total_price) VALUES (?, ?, ?, ?)',
      [user_id, resource_id, quantity, total_price]
    );

    // 4. Deduct the stock
    await db.query(
      'UPDATE resources SET stock = stock - ? WHERE id = ?', 
      [quantity, resource_id]
    );

    res.status(201).json({ message: 'Purchase successful', total_price });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const getPurchaseHistory = async (req, res) => {
  const user_id = req.user.id;
  
  try {
    const [rows] = await db.query(
      `SELECT p.*, r.name, r.image, r.type 
       FROM purchases p 
       JOIN resources r ON p.resource_id = r.id 
       WHERE p.user_id = ? 
       ORDER BY p.purchased_at DESC`,
      [user_id]
    );
    
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

module.exports = { buyResource, getPurchaseHistory };