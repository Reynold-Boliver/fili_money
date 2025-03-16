# fili_money

fili_money is a Flutter-based application designed for tracking finances. The app provides an intuitive way to manage your income and expenses while offering insightful data visualizations to help you understand your financial health. It leverages Firebase as its backend database, ensuring real-time data updates and secure storage.

## Features

- **Expense & Income Tracking:** Log your daily expenses and income to keep a close eye on your financial status.
- **Data Visualization:** View charts and graphs that help illustrate your spending habits and trends.
- **Firebase Integration:** Utilizes Firebase Firestore for real-time database management and Firebase Authentication for secure user sign-in.
- **User-Friendly Interface:** Designed with simplicity in mind to ensure an easy and enjoyable user experience.

## Getting Started

Follow these steps to set up the project on your local machine.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) – Ensure you have Flutter installed.
- A [Firebase](https://firebase.google.com/) account – Needed for setting up the backend services.

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/fili_money.git
   cd fili_money

2. **Install dependencies**
    ```sh
   flutter pub get
3. **Configure Firebase:**

   - Create a new project in the Firebase Console.
   - Add your Android and/or iOS app to the Firebase project.
   - Download the configuration file:
        - For Android: Place [google-services.json]() in the [android/app]() directory.
        - For iOS: Place [GoogleService-Info.plist]() in the [ios/Runner]() directory.
   - Follow the [FlutterFire](https://firebase.flutter.dev/docs/overview/) documentation to integrate Firebase into your Flutter project.
   
4. **Run app**
   ````sh
   flutter run
   
**Build With**
- [Flutter](https://flutter.dev/) - The mobile app framework used for building the UI.
- [Firebase](https://firebase.google.com/) - Provides backend services including real-time database and authentication.

**Contributing**

Contributions are welcome! If you have any suggestions or improvements, please open an issue or submit a pull request.

**License**

This project is licensed under the MIT License - see the [LICENSE]() file for details.

---
