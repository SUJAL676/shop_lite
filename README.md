# 🛍️ ShopLite - Flutter E-commerce App

A modern and compact e-commerce application built with Flutter, showcasing clean architecture, BLoC state management, offline-first capabilities, and polished UI/UX.

---

## 📱 App Overview

ShopLite is a lightweight shopping app that demonstrates end-to-end Flutter fundamentals:

* Product catalog with pagination (infinite scroll)
* Search & category filtering
* Product detail with animations
* Favorites & cart with persistence
* Offline-first support using local cache
* Mock authentication with secure token storage
* Smooth UI/UX with animations

---


### Layers:

* **Presentation Layer**

  * UI + BLoC
* **Domain Layer**

  * Business logic (use cases)
* **Data Layer**

  * API services + local storage

---

## 🔄 State Management

Used **BLoC (flutter_bloc)**

### Why BLoC?

* Predictable state transitions
* Separation of UI and logic
* Easy to test
* Scalable for large apps

---

## 🌐 Networking

* API Used: https://dummyjson.com/
* HTTP Client: Dio

### Features:

* Pagination
* Search
* Category filtering

---

## 💾 Caching Strategy & Offline Behavior

### Storage:

* Hive (local database)

### Strategy:

* Latest API response is cached locally
* App follows **offline-first approach**
* If network fails → cached data is shown
* Offline banner is displayed

### Connectivity:

* `connectivity_plus` for real-time network detection
* Internet validation check added

---

## 🛒 Features Implemented

* Infinite scrolling product list
* Search & category filters
* Product detail with Hero animation
* Add/remove favorites (persistent)
* Cart management:

  * Add/remove items
  * Update quantity
  * Auto remove when quantity = 0
* Order summary calculation
* Mock checkout flow
* Animated order success screen
* Offline support
* Responsive UI (no fixed dimensions)

---

## ▶️ How to Run

### 📱 Android / Emulator

```bash
git clone <your-repo-link>
cd shoplite
flutter pub get
flutter run
```

---

### 🍎 iOS / Simulator

```bash
cd ios
pod install
cd ..
flutter run
```

---

## 🧪 Testing

The project includes unit and widget tests.

For record : https://drive.google.com/drive/folders/1VrKyZ5yaNWiK2xSDxmGMUEl_7BLG0E1G?usp=sharing

### ✅ Unit Tests

* Product Repository (API)
* Cart logic (add/remove/update)
* Bloc state transitions

### 🧩 Example Coverage

* Fetch products
* Validate product data
* Add item to cart
* Remove item from cart
* Bloc emits correct states

### ▶️ Run Tests

```bash
flutter test
```

---

## ⚙️ CI (Continuous Integration)

GitHub Actions is used to automate:

* Code formatting
* Static analysis
* Running tests

### ✅ CI Badge

```md
![CI](https://github.com/<your-username>/<repo>/actions/workflows/flutter_ci.yml/badge.svg)
```



---

## ⚠️ Known Trade-offs / Limitations

* Authentication is mock-based (no real backend)
* No real payment gateway integration
* Basic caching strategy (no TTL expiry)
* Limited API error handling

---

## 🚀 Future Improvements

* Real authentication system
* Payment gateway integration
* Push notifications
* Advanced caching (TTL-based)
* Better error handling

---

## 📦 Tech Stack

* Flutter
* BLoC (flutter_bloc)
* Dio
* Hive
* CachedNetworkImage
* Lottie
* Connectivity Plus
* Flutter Secure Storage

---

## 🎥 Demo Video

👉 https://drive.google.com/file/d/1bVgse04HOwvyIvMkjCCgbzUx2dROyLjT/view?usp=sharing

---

## 👨‍💻 Author

**Sujal Kanojia**

---

## 📌 Conclusion

This project demonstrates:

* Clean architecture implementation
* Scalable state management using BLoC
* Offline-first design
* Production-level UI/UX practices
