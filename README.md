# 🌾 AgriGuard – Smart Agrochemical Management for Sustainable Farming

> 🚀 Developed by **Anuj Gadekar**  
> 📱 Cross-platform mobile solution | 🌐 Firebase-powered backend  
 

AgriGuard is an advanced agrochemical management application built to transform traditional farming with **precision, safety, and sustainability** at its core. Designed using scalable architecture and modern design principles, AgriGuard empowers farmers with weather intelligence, dosage automation, and regulatory compliance—right from their smartphone.

---

## 🔥 Unique Features

- 🧪 **AI-Enhanced Dosage Calculator**  
  Calculates exact chemical dosage based on area, concentration, and crop type.

- 🌦️ **Real-Time Weather Integration**  
  Smart scheduling of chemical application using live weather forecasts (OpenWeatherMap API or similar).

- 📅 **Treatment Timeline & Alerts**  
  Smart logs with chemical, time, and location—reminders prevent over-application.

- 📜 **Regulatory Compliance Toolkit**  
  Access to local agrochemical guidelines, safety tips, and usage laws.

- 🌍 **Multilingual & Inclusive UI** *(Planned)*  
  Designed to support multiple Indian and global languages for broader adoption.

- 📡 **IoT Integration Ready** *(Planned)*  
  Future-proof design supports soil sensors, smart sprayers, and automated recommendations.

---

## 🧰 Full Tech Stack

| Layer            | Technology                              |
|------------------|------------------------------------------|
| **Frontend**     | Flutter (Dart), Material Design, Iconsax |
| **State Mgmt**   | `Provider` (Flutter's declarative pattern) |
| **Backend (BaaS)** | Firebase Authentication, Firestore (NoSQL DB), Cloud Functions |
| **Push Alerts**  | Firebase Cloud Messaging (FCM)           |
| **DevOps**       | GitHub Actions (CI/CD), Firebase CLI     |
| **Testing**      | Flutter Unit & Widget Testing            |
| **Other Tools**  | Android Studio, VS Code, Gradle          |

---

## 🧩 Design Pattern & Architecture

AgriGuard follows a **modular & scalable architecture**, adhering to:

- 🧠 **MVVM (Model-View-ViewModel)** for UI-business logic separation
- ♻️ **Repository Pattern** to abstract data access (Firestore, Local cache)
- 🧾 **Service Layer** for encapsulated Firebase and weather API logic
- 🔄 **Provider** for reactive state management across widgets

---


---

## 🚀 Getting Started

### ⚙️ Prerequisites

- Flutter SDK (>=3.0)
- Dart SDK
- Firebase Project (Auth + Firestore + FCM)
- Android Studio or Visual Studio Code

### 🧪 Installation

```bash
# Clone the repo
git clone 
cd AgriGuard

# Install dependencies
flutter pub get

# Run the app
flutter run
🔒 Security & Best Practices
✅ Secrets managed via .env (excluded using .gitignore)

✅ Firestore rules enforced to prevent unauthorized access

✅ CI pipeline checks for accidental secrets (GitLeaks / TruffleHog)

🛠️ Firebase Setup Instructions (Optional)
Only if needed by collaborators

Create Firebase project

Enable Firestore and Authentication

Download google-services.json → place in android/app/

Enable Firebase Cloud Messaging (FCM) for notifications

🔮 Future Enhancements
🌐 Language packs for Hindi, Marathi, and regional languages

📡 IoT: Soil sensors, real-time pH data, smart drone sprayers

📊 Analytics Dashboard for admin monitoring

🤝 Farmer social forum & live expert chat


![image](https://github.com/user-attachments/assets/0be16640-0ec5-4656-83df-1fb614f07c0b)


📝 License
This project is licensed under the MIT License – see LICENSE for details.

