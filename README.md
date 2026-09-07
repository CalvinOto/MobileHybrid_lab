# Retail App

A full-stack mobile commerce application inspired by Honkai: Star Rail, built for the Mobile Hybrid Lab Course.

---

## Tech Stack

* **Frontend:** Flutter SDK 3.32.2 (Dart) on Android API 35
* **Backend:** Node.js v22.16.0 & Express.js
* **Database:** MySQL via XAMPP
* **Authentication:** JWT Bearer tokens & Google OAuth
* **Key Libraries:** `bcryptjs`, `jsonwebtoken`, `multer`, `google_sign_in`

---

## Key Features

* **Role-Based Access Control:** Separate interfaces and permissions for `User` and `Admin` accounts.
* **Resource Catalog & Filtering:** Search items by name or filter by category (Light Cone, Material, Relic, Other).
* **Purchases & Checkout:** Select quantity via bottom sheet with live stock validation and view purchase history.
* **Admin Dashboard:** Full CRUD management to add, update, and delete resources with image upload support.
* **Data Validation:** Form-level validation for emails, strong passwords, stock quantities, and prices.

---

## Demo Credentials

* **Admin:** `admin@gmail.com` / `admin123`
* **User:** `user@gmail.com` / `user123` (or sign in via Google OAuth)

---

## How to Run

1. Start MySQL in **XAMPP** and import the `.sql` database file.
2. Run the setup and start commands:

```bash
# Start backend server
cd backend && npm install && npm start

# In a second terminal, launch the Flutter mobile app
cd frontend && flutter pub get && flutter run
