# Farm Direct  

**Farm Direct** is a mobile application designed to connect Canadian farmers directly with consumers. It allows farmers to create profiles, list their products, and manage orders efficiently. Consumers can explore a wide variety of fresh, local produce, search for products, and place orders directly through the app.  

---

## Features  

### For Consumers  
- **Browse Categories:** Explore products organized by categories like Fruits, Vegetables, and more.  
- **Search and Filter:** Find specific products or farmers easily using search and filter options.  
- **Product Details:** View detailed information about available produce, including price and availability.  
- **Order Placement:** Place orders directly with farmers and track the order status.  

### For Farmers  
- **Profile Management:** Create and update personal and farm profiles.  
- **Product Management:** Add, update, or remove product listings.  
- **Order Management:** View and update order statuses to keep consumers informed.  
- **Dashboard:** Track key metrics like total products listed and pending orders.  

### General Features  
- **Firebase Integration:** Real-time database updates and authentication.  
- **User-Friendly Interface:** Intuitive UI for seamless navigation and interaction.  
- **Scalable Backend:** Built using Firebase to support future growth.  

---

## Technology Stack  

- **Frontend:** Flutter (Dart)  
- **Backend:** Firebase Realtime Database  
- **Authentication:** Firebase Authentication  
- **Testing:** Flutter Testing Framework  
- **Version Control:** GitHub  

---


# Getting Started  

## Prerequisites  
- **Flutter SDK:** Install from [Flutter](https://flutter.dev/).  
- **Firebase Project:** Set up a Firebase project and configure `google-services.json` for Android and `GoogleService-Info.plist` for iOS.  

## Installation  

1. **Clone the repository:**  
   ```bash  
   git clone https://github.com/username/projectname  
   cd projectname  

2. **Install dependencies:**
    ```bash
    flutter pub get
    
3. **Configure Firebase:**
    - Add `google-services.json` in the `android/app` directory.
    - Add `GoogleService-Info.plist` in the `ios/Runner` directory.

4. **Run the app:**
  ```bash
  flutter run
