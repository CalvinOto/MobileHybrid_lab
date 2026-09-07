const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const { verifyToken, verifyAdmin } = require('../middleware/auth');
const {
  getAllResources, getResourceById,
  createResource, updateResource, deleteResource
} = require('../controllers/resourceController');

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname))
});
const upload = multer({ storage });

router.get('/', verifyToken, getAllResources);
router.get('/:id', verifyToken, getResourceById);
router.post('/', verifyToken, verifyAdmin, upload.single('image'), createResource);
router.put('/:id', verifyToken, verifyAdmin, upload.single('image'), updateResource);
router.delete('/:id', verifyToken, verifyAdmin, deleteResource);

module.exports = router;