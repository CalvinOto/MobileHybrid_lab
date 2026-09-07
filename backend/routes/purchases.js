const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/auth');
const { buyResource, getPurchaseHistory } = require('../controllers/purchaseController');

router.post('/buy', verifyToken, buyResource);
router.get('/history', verifyToken, getPurchaseHistory);

module.exports = router;