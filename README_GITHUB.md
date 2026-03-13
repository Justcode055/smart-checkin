# Smart Class Check-in & Learning Reflection App

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![Dart](https://img.shields.io/badge/Dart-3.0+-green)
![SQLite](https://img.shields.io/badge/SQLite-3+-yellow)
![License](https://img.shields.io/badge/License-MIT-purple)

A Flutter mobile application that automates university attendance verification and captures meaningful learning data through reflective assessments.

## 📱 Project Overview

**Smart Class Check-in & Learning Reflection App** is an MVP (Minimum Viable Product) designed to help universities:
- ✅ **Verify physical attendance** in real-time with GPS-based location confirmation
- ✅ **Measure learning engagement** through structured pre & post-class reflections
- ✅ **Track student sentiment** about learning progress and teaching quality
- ✅ **Store data locally** with offline-first functionality (SQLite)
- ✅ **Sync to cloud** for analytics dashboard (Firebase integration in Phase 2)

**Target Users:**
- 👨‍🎓 Students — Quick check-in/out and reflection submission
- 👨‍🏫 Instructors — Real-time attendance monitoring (Phase 2)
- 🏫 University Admins — Attendance & learning analytics (Phase 2)

---

## ✨ Features

### Core Features (MVP)
| Feature | Status | Description |
|---------|--------|-------------|
| **QR Code Check-in** | ✅ Complete | Students scan QR code at entrance |
| **GPS Location Tracking** | ✅ Complete | Records precise latitude/longitude |
| **Pre-Class Reflection** | ✅ Complete | Topic recap + mood score (1-5) |
| **QR Code Check-out** | ✅ Complete | Students scan QR code at exit |
| **Post-Class Reflection** | ✅ Complete | Learning summary + instructor feedback |
| **Local Data Storage** | ✅ Complete | SQLite database, offline-first |
| **Session History** | ⏳ In Progress | View past check-in/out records |

### Future Features (Phase 2+)
- 📊 Instructor Dashboard (real-time attendance view)
- 📈 Analytics Dashboard (learning trends, attendance patterns)
- ☁️ Firebase Cloud Integration (data sync & backup)
- 🔐 SSO Authentication (university credentials)
- 📧 Email Notifications (attendance reminders)
- 🌍 Multi-language Support

---

## 🛠️ Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Frontend** | Flutter (Dart) | 3.0+ |
| **Mobile Platforms** | iOS + Android | iOS 13+, Android 23+ |
| **Local Database** | SQLite | 3+ |
| **Location Services** | Geolocator | 9.0+ |
| **QR Scanning** | mobile_scanner | 3.0+ |
| **State Management** | Provider | 6.0+ |
| **Local Storage** | SharedPreferences | 2.0+ |
| **Date Formatting** | intl | 0.18+ |
| **Backend (Future)** | Firebase | Realtime DB / Firestore |

**Development Tools:**
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / Xcode
- Git / GitHub

---

## 🚀 Setup Instructions

### Prerequisites
Ensure you have the following installed:
- **Flutter SDK** 3.0+ — [Download](https://flutter.dev/docs/get-started/install)
- **Dart SDK** 3.0+ — (Included with Flutter)
- **Android Studio** or **Xcode** (for emulator)
- **Git** — [Download](https://git-scm.com/)

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/smart-class-checkin.git
cd smart-class-checkin
```

### Step 2: Install Flutter Dependencies
```bash
flutter pub get
```

### Step 3: Verify Flutter Setup
```bash
flutter doctor
```
Ensure all required components show ✓

### Step 4: Create Emulator (if needed)
**For Android:**
```bash
flutter emulators --launch Pixel_6_API_31
```

**For iOS:**
```bash
open -a Simulator
```

### Step 5: Run Android Permissions Setup
Edit `android/app/src/main/AndroidManifest.xml` and add:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
```

---

## 📲 Running the Flutter App

### Run on Emulator/Simulator
```bash
# Detect available devices
flutter devices

# Run on Android emulator
flutter run

# Run on iOS simulator
flutter run -d macos
```

### Run on Physical Device
Connect your device via USB and enable Developer Mode, then:
```bash
flutter run
```

### Build Release APK (Android)
```bash
flutter build apk --release
```
Output: `build/app/outputs/apk/release/app-release.apk`

### Build Release IPA (iOS)
```bash
flutter build ios --release
```

### Debug Mode with Hot Reload
```bash
flutter run
# Press 'r' for hot reload
# Press 'R' for hot restart
```

---

## 🔥 Firebase Deployment (Phase 2)

### Step 1: Set Up Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (e.g., "smart-class-checkin")
3. Enable Realtime Database and/or Firestore

### Step 2: Install FlutterFire CLI
```bash
npm install -g firebase-tools
flutter pub global activate flutterfire_cli
```

### Step 3: Configure Firebase for Flutter
```bash
flutterfire configure
```
Select your Firebase project and platforms (iOS, Android)

### Step 4: Add Firebase Dependencies
```bash
flutter pub add firebase_core
flutter pub add firebase_database  # or cloud_firestore
```

### Step 5: Initialize Firebase in main.dart
```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### Step 6: Deploy to Firebase Hosting
```bash
firebase deploy
```

---

## 📁 Folder Structure

```
lib/
├── main.dart                          # App entry point, routing config
├── screens/                           # UI Screens
│   ├── home_screen.dart              # Navigation hub
│   ├── check_in_screen.dart          # Check-in with GPS + QR + form
│   └── finish_class_screen.dart      # Check-out with reflection
├── models/                            # Data models
│   ├── attendance.dart               # Attendance record model
│   └── reflection.dart               # Reflection data model
├── services/                          # Business logic
│   ├── location_service.dart         # GPS location retrieval
│   ├── qr_service.dart               # QR code scanning
│   ├── database_service.dart         # Database CRUD operations
│   └── storage_service.dart          # SharedPreferences wrapper
├── widgets/                           # Reusable UI components
│   ├── custom_button.dart            # Custom styled button
│   ├── mood_slider.dart              # Mood score selector (1-5)
│   └── loading_spinner.dart          # Reusable loading indicator
├── utils/                             # Utility functions
│   ├── constants.dart                # App-wide constants
│   ├── validators.dart               # Form validation logic
│   └── helpers.dart                  # Helper functions
└── db/                                # Database layer
    └── database_helper.dart          # SQLite schema & CRUD

android/                              # Android native code
├── app/src/main/AndroidManifest.xml # Permissions & permissions
└── build.gradle.kts                  # Build configuration

ios/                                  # iOS native code
└── Runner/Info.plist                 # Permissions configuration

web/                                  # Web platform (future)
linux/                                # Linux platform (future)
macos/                                # macOS platform (future)
windows/                              # Windows platform (future)

pubspec.yaml                          # Flutter dependencies
analysis_options.yaml                 # Dart linter rules
README.md                             # This file
```

---

## 📊 Database Schema

### class_sessions Table
```sql
CREATE TABLE class_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  checkin_time TEXT NOT NULL,
  checkout_time TEXT,
  qr_code TEXT,
  checkout_qr_code TEXT,
  gps_lat REAL NOT NULL,
  gps_long REAL NOT NULL,
  checkout_lat REAL,
  checkout_long REAL,
  previous_topic TEXT,
  expected_topic TEXT,
  mood INTEGER,
  learned_today TEXT,
  feedback TEXT,
  created_at TEXT NOT NULL,
  synced INTEGER DEFAULT 0
);
```

---

## 🔄 Workflow

### Student Check-in Flow
```
1. Open App → Home Screen
2. Tap "Check In" → Check-in Screen
3. Allow GPS permission
4. System captures GPS location
5. Scan QR code at classroom entrance
6. Fill pre-class reflection form:
   - Previous class topic
   - Expected topic today
   - Mood score (1-5)
7. Tap "Submit Check-in"
8. Data saved locally (SQLite) ✓
9. Return to Home Screen
```

### Student Check-out Flow
```
1. Tap "Finish Class" → Finish Class Screen
2. Scan QR code at classroom exit
3. System captures exit GPS location
4. Fill post-class reflection form:
   - What you learned today
   - Feedback for instructor
5. Tap "Submit Reflection"
6. Data saved locally (SQLite) ✓
7. Return to Home Screen
```

---

## 🧪 Testing

### Unit Tests
```bash
flutter test test/unit_test.dart
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue:** "Flutter doctor" shows missing dependencies
```bash
flutter doctor --verbose
flutter upgrade
```

**Issue:** Android emulator won't start
```bash
flutter emulators --launch Pixel_6_API_31 --verbose
```

**Issue:** iOS build fails
```bash
cd ios
rm -rf Pods
pod install
cd ..
flutter run
```

**Issue:** GPS permission not granted
- Check `AndroidManifest.xml` has location permissions
- On device: Settings → Apps → Permissions → Location → Allow

**Issue:** QR code scanner not working
- Check camera permissions are granted
- Ensure good lighting when scanning
- Try scanning from phone screen vs. printed QR codes

---

## 📈 Performance Metrics (MVP)

| Metric | Target | Status |
|--------|--------|--------|
| Check-in completion time | < 2 minutes | ✅ Meets |
| App startup time | < 2 seconds | ✅ Meets |
| Reflection form completion rate | > 80% | 📊 To measure |
| GPS accuracy | ±50m campus radius | ✅ Meets |
| Data persistence (SQLite) | 100% offline | ✅ Meets |
| Screen responsiveness | < 300ms | ✅ Meets |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format code
- Run `flutter analyze` before committing

---

## 📄 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) file for details.

---

## 👥 Authors & Contributors

- **Product Manager:** [Your Name](https://github.com/yourusername)
- **Lead Developer:** [Your Name](https://github.com/yourusername)
- **UI/UX Designer:** [Your Name](https://github.com/yourusername)

---

## 📞 Support & Contact

For questions, issues, or suggestions:
- 📧 **Email:** support@smartclasscheckin.com
- 🐛 **Issues:** [GitHub Issues](https://github.com/yourusername/smart-class-checkin/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/yourusername/smart-class-checkin/discussions)

---

## 📚 Additional Resources

### Documentation
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [SQLite in Flutter](https://pub.dev/packages/sqflite)
- [Firebase Flutter Guide](https://firebase.flutter.dev/)

### Tutorials
- [Flutter Codelab](https://codelabs.developers.google.com/?cat=flutter)
- [State Management in Flutter](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)

### Related Projects
- [Flutter Attendance App](https://github.com/example/flutter-attendance)
- [QR Code Scanner Example](https://github.com/example/qr-scanner)

---

## 🗺️ Roadmap

### Version 1.0 (Current MVP - March 2026)
- [x] Core check-in functionality
- [x] GPS location tracking
- [x] QR code scanning
- [x] Pre/post-class reflections
- [x] Local SQLite storage
- [x] Mobile (iOS + Android)

### Version 2.0 (Q2 2026)
- [ ] Firebase Cloud Integration
- [ ] Instructor Dashboard
- [ ] Analytics Dashboard
- [ ] SSO Authentication
- [ ] Email Notifications

### Version 3.0 (Q4 2026)
- [ ] Machine Learning (learning trend prediction)
- [ ] Advanced Analytics
- [ ] Multi-university Support
- [ ] API for 3rd-party integrations

---

## 📝 Changelog

### [1.0.0] - March 13, 2026
**Initial MVP Release**
- ✅ Complete check-in/check-out flow
- ✅ GPS location + QR code scanning
- ✅ Pre/post-class reflection forms
- ✅ Local SQLite database
- ✅ Offline-first functionality

---

**Last Updated:** March 13, 2026  
**Status:** Active Development 🚀
