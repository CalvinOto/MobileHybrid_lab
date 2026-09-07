const db = require('../db');

const getAllResources = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM resources');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const getResourceById = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM resources WHERE id = ?', 
      [req.params.id]
    );
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Resource not found' });
    }
    
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const createResource = async (req, res) => {
  const { name, type, description, stock, price } = req.body;
  const image = req.file ? req.file.filename : null;

  if (!name || !type || !stock || !price) {
    return res.status(400).json({ message: 'Name, type, stock and price are required' });
  }

  try {
    await db.query(
      `INSERT INTO resources 
      (name, type, description, stock, image, price) 
      VALUES (?, ?, ?, ?, ?, ?)`,
      [name, type, description, stock, image, price]
    );
    
    res.status(201).json({ message: 'Resource created successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const updateResource = async (req, res) => {
  const { name, type, description, stock, price } = req.body;
  
  // Keep the new uploaded image, OR fallback to the existing image string sent from frontend
  const image = req.file ? req.file.filename : req.body.image;

  if (!name || !type || !stock || !price) {
    return res.status(400).json({ message: 'Name, type, stock and price are required' });
  }

  try {
    const [result] = await db.query(
      `UPDATE resources 
       SET name=?, type=?, description=?, stock=?, image=?, price=? 
       WHERE id=?`,
      [name, type, description, stock, image, price, req.params.id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Resource not found' });
    }

    res.json({ message: 'Resource updated successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const deleteResource = async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM resources WHERE id = ?', 
      [req.params.id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Resource not found' });
    }

    res.json({ message: 'Resource deleted successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

module.exports = { 
  getAllResources, 
  getResourceById, 
  createResource, 
  updateResource, 
  deleteResource 
};