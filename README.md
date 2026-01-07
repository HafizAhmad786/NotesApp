📝 NotesApp - Flutter Firebase Technical Assignment
A secure notes application built with Flutter and Firebase, featuring authentication, CRUD operations, and user-specific data management.

📱 Features
🔐 Authentication: Email/password sign-up, login, and persistent sessions
📒 Notes Management: Full CRUD operations (Create, Read, Update, Delete)
🛡️ Security: Users can only access their own notes via Firebase Security Rules

🎨 Clean UI: Material Design with intuitive navigation
📱 Android APK: Production-ready build included

🏗️ Tech Stack
Flutter (3.38.1)
Firebase (Authentication + Cloud Firestore)
Provider (State Management)
Intl (Date formatting)

🚀 Getting Started
Prerequisites
Dart (>=3.10.0)
Android Studio
Firebase account

🔐 Authentication Flow
Splash Screen: Checks if user is already authenticated

If authenticated: Redirects to Notes Screen
If not authenticated: Redirects to Login Screen
Login/Signup: Uses Firebase Auth with email/password
Session Persistence: Firebase Auth automatically persists sessions
>>>>>>> b70c22eab60fb30ce4e982095c737b4ff5ccc94a
