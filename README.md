# 🛍️ ShopLite - Flutter E-commerce App

A compact and modern e-commerce application built using Flutter, demonstrating clean architecture, state management, offline-first approach, and smooth UI/UX.

---

## 📱 Features

### 🔐 Authentication (Mock)
- Email & password login
- Token stored securely
- Protected cart access

### 🏠 Catalog
- Paginated product listing (infinite scroll)
- Search functionality
- Category filtering
- Pull-to-refresh
- Hero animation to detail screen

### 📦 Product Detail
- Image preview with animation
- Price, rating, description
- Add/Remove from cart
- Add/Remove favorites

### ❤️ Favorites
- Mark/unmark favorite products
- Persistent storage (Hive)

### 🛒 Cart & Checkout
- Add/remove items
- Update quantity
- Auto remove when quantity = 0
- Order summary calculation
- Mock “Place Order” flow
- Animated success screen

### 🌐 Offline Support
- Cached product data using Hive
- Offline banner
- Works without internet

### 🎨 UI/UX
- Responsive UI (no fixed dimensions)
- Light theme
- Smooth animations (Lottie + custom)
- Proper loading / empty / error states

---


### Layers:
- **Presentation** → UI + Bloc
- **Domain** → Business logic
- **Data** → API + Local storage

---

## 🧠 State Management

Used **BLoC (flutter_bloc)**

Why BLoC?
- Predictable state flow
- Separation of concerns
- Easy testing
- Scalable for production apps

---

## 🌐 Networking

- API: https://dummyjson.com/
- Package: `dio`
- Features:
  - Pagination
  - Search
  - Category filtering

---

## 💾 Caching Strategy

- Local DB: Hive
- Cached:
  - Products
  - Favorites
  - Cart

### Strategy:
- Offline-first approach
- Last successful API response stored
- TTL (can be extended)

### Testing 
 - https://drive.google.com/drive/folders/1VrKyZ5yaNWiK2xSDxmGMUEl_7BLG0E1G?usp=sharing
 - Follow above link for testing records

---

## 📦 Dependencies

```yaml
flutter_bloc
dio
hive
hive_flutter
cached_network_image
lottie
connectivity_plus
flutter_secure_storage