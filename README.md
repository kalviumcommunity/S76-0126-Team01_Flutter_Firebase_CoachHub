<!-- Animated Typing Header -->
<p align="center">
  <img src="https://readme-typing-svg.herokuapp.com?font=Poppins&size=28&duration=3000&color=4CAF50&center=true&vCenter=true&width=600&lines=Coachub+🚀;Smart+Learning+Platform;Flutter+×+Firebase+Ecosystem" />
</p>

<p align="center">
  <b>🎓 Empowering the next generation through role-based connectivity.</b>
</p>

---

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/Firebase-Backend-orange?style=for-the-badge&logo=firebase" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge" />
</p>

---

# ✨ Overview

Coachub is a sophisticated **Flutter-based mobile application** designed to bridge the gap between **Teachers** and **Students**.

Built with a **modular architecture** and powered by **Firebase services**, it delivers a seamless, scalable, and real-time educational ecosystem.

---

# 🚀 Key Features

| Feature | Description |
|----------|------------|
| 🔐 Secure Authentication | Role-based login & sign-up powered by Firebase Auth |
| ⚡ Real-Time Database | Live streaming via Cloud Firestore |
| 🧭 Dynamic Routing | Centralized Named Routes inside `main.dart` |
| 🎨 High-Fidelity UI | Pixel-aligned layouts with smooth animations |
| 📊 Role-Based Dashboards | Separate Teacher & Student views |

---

# 🛠 Tech Stack

<p align="center">

| Component | Technology | Purpose |
|------------|------------|----------|
| 🎨 Frontend | Flutter (Dart) | Cross-platform UI rendering |
| ☁ Backend | Firebase | Scalable cloud infrastructure |
| 🔐 Authentication | Firebase Auth | Secure identity management |
| 📂 Database | Cloud Firestore | Real-time NoSQL storage |
| 🧭 Navigation | Named Routes | Structured app flow |

</p>

---

# 🔐 Authentication Flow

Coachub follows a **Dual-Pathway Logic System** to ensure users land on the correct dashboard instantly after login.

### 👥 Role Selection
- Teacher  
- Student  

### 📁 Data Persistence
User role is stored in a `users` collection in Firestore.

### 🔄 Auth Wrapper
An `AuthCheck` widget listens to authentication state changes and routes users dynamically.

---

# 📦 Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/coachub.git

# Navigate into project
cd coachub

# Install dependencies
flutter pub get

# Run application
flutter run
