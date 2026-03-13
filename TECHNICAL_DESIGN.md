# Technical Design Document
## Smart Class Check-in & Learning Reflection App

**Version:** 1.0 | **Date:** March 2026 | **Build Time:** 3 hours MVP

---

## 1. Flutter Folder Structure

```
lib/
├── main.dart                          # App entry point, theme, routing
├── screens/
│   ├── home_screen.dart              # Home screen - navigation hub
│   ├── check_in_screen.dart          # Check-in with QR + GPS + form
│   └── finish_class_screen.dart      # Check-out with reflection form
├── models/
│   ├── attendance.dart               # Attendance model (check-in/out)
│   └── reflection.dart               # Reflection model (pre/post class)
├── services/
│   ├── location_service.dart         # GPS location retrieval
│   ├── qr_service.dart               # QR code scanning
│   ├── database_service.dart         # SQLite operations
│   └── storage_service.dart          # SharedPreferences for simple data
├── widgets/
│   ├── custom_button.dart            # Reusable button widget
│   ├── mood_slider.dart              # Mood score selector (1-5)
│   └── loading_spinner.dart          # Reusable loading indicator
├── utils/
│   ├── constants.dart                # App constants, colors, strings
│   ├── validators.dart               # Form validation logic
│   └── helpers.dart                  # Helper functions
└── db/
    └── database_helper.dart          # Database schema & operations
```

---

## 2. Main Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management & Navigation
  provider: ^6.0.0                 # Lightweight state management
  get: ^4.6.0                      # Alternative: navigation + state
  
  # Location Services
  geolocator: ^9.0.0               # GPS location retrieval
  
  # QR Code Scanning
  qr_code_scanner: ^1.0.0          # QR scanning (mobile only)
  # qr: ^3.0.0                     # Alternative: QR code generation
  
  # Local Database
  sqflite: ^2.2.0                  # SQLite database
  path: ^1.8.0                     # File path manipulation
  
  # Local Storage (key-value)
  shared_preferences: ^2.0.0       # Simple SharedPreferences
  
  # UI/UX
  intl: ^0.18.0                    # Date/time formatting
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_linter:
    sdk: flutter
```

---

## 3. Folder Structure Explanation

| Folder | Purpose | Contents |
|--------|---------|----------|
| **screens/** | All UI pages | Home, Check-in, Finish Class - user-facing screens |
| **models/** | Data classes | `Attendance` (check-in/out records), `Reflection` (learning data) |
| **services/** | Business logic | GPS, QR scanning, database, storage operations |
| **widgets/** | Reusable UI | Custom buttons, mood slider, loading spinner |
| **utils/** | Utilities | Constants, validation, helper functions |
| **db/** | Database | SQLite schema initialization & CRUD operations |

**Key Files Breakdown:**

### `main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
```

### `models/attendance.dart`
```dart
class Attendance {
  final int? id;
  final String studentId;
  final String classId;
  final DateTime checkInTime;
  final double latitude;
  final double longitude;
  final String qrCode;
  final DateTime? checkOutTime;

  Attendance({...});
  
  Map<String, dynamic> toMap() { ... }
  factory Attendance.fromMap(Map<String, dynamic> map) { ... }
}
```

### `models/reflection.dart`
```dart
class Reflection {
  final int? id;
  final String studentId;
  final String classId;
  final String type; // 'pre' or 'post'
  
  // Pre-class
  final String? previousTopic;
  final String? expectedTopic;
  final int? moodScore;
  
  // Post-class
  final String? whatLearned;
  final String? feedback;
  
  final DateTime createdAt;

  Reflection({...});
  
  Map<String, dynamic> toMap() { ... }
  factory Reflection.fromMap(Map<String, dynamic> map) { ... }
}
```

### `services/location_service.dart`
```dart
class LocationService {
  static Future<Position> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
    return await Geolocator.getCurrentPosition();
  }
}
```

### `services/qr_service.dart`
```dart
class QrService {
  static Future<String> scanQrCode() async {
    final result = await QRViewController.scanQrCode();
    return result.code ?? '';
  }
}
```

### `services/database_service.dart`
```dart
class DatabaseService {
  Future<int> saveAttendance(Attendance attendance) async {
    return await DatabaseHelper.insertAttendance(attendance);
  }
  
  Future<int> saveReflection(Reflection reflection) async {
    return await DatabaseHelper.insertReflection(reflection);
  }
  
  Future<List<Attendance>> getAttendanceRecords() async {
    return await DatabaseHelper.getAttendances();
  }
}
```

---

## 4. Navigation Flow

```
┌─────────────────┐
│   Home Screen   │
├─────────────────┤
│ • Check in      │ ─────────┐
│ • Finish Class  │          │
│ • View History  │          │
└─────────────────┘          │
                             ▼
                 ┌──────────────────────┐
                 │  Check-in Screen     │
                 ├──────────────────────┤
                 │ 1. Scan QR Code      │
                 │ 2. Get GPS Location  │
                 │ 3. Pre-class Form    │
                 │    - Previous topic  │
                 │    - Expected topic  │
                 │    - Mood (1-5)      │
                 │ 4. Save & Return     │
                 └──────────────────────┘
                         │
                         ▼
                 ┌──────────────────────┐
           ┌────►│   Home Screen        │
           │     └──────────────────────┘
           │
           │     [Class in Progress]
           │
           │     ┌──────────────────────┐
           └─────│ Finish Class Screen  │
                 ├──────────────────────┤
                 │ 1. Scan QR Code      │
                 │ 2. Post-class Form   │
                 │    - What learned    │
                 │    - Feedback        │
                 │ 3. Save & Return     │
                 └──────────────────────┘
```

---

## 5. Screen Layouts (MVP)

### Home Screen
```
[LOGO / Title]
Smart Class Check-in

[Button] Check In →
[Button] Finish Class ↓ (disabled until check-in)
[Button] View History

[Recent Check-ins List]
```

### Check-in Screen
```
[Back] Check In

[1] Scan QR Code
    [QR Scanner View / Button]
    QR Result: XXXX-XXXX-XXXX

[2] GPS Location
    ✓ Latitude: 40.1234
    ✓ Longitude: -74.5678

[3] Reflection Form
    Previous class topic: [text input]
    Expected topic today: [text input]
    How are you feeling? [Mood Slider 1-5]

[Save & Check In]
```

### Finish Class Screen
```
[Back] Finish Class

[1] Scan QR Code (Exit)
    [QR Scanner View / Button]
    QR Result: XXXX-XXXX-XXXX

[2] Learning Reflection
    What did you learn today?
    [Text input, multiline]
    
    Feedback for class/instructor:
    [Text input, multiline]

[Save & Check Out]
```

---

## 6. SQLite Database Schema

### attendance table
```sql
CREATE TABLE attendance (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL,
  class_id TEXT NOT NULL,
  check_in_time TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  qr_code TEXT NOT NULL,
  check_out_time TEXT,
  synced INTEGER DEFAULT 0,
  created_at TEXT NOT NULL
);
```

### reflection table
```sql
CREATE TABLE reflection (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL,
  class_id TEXT NOT NULL,
  type TEXT NOT NULL, -- 'pre' or 'post'
  previous_topic TEXT,
  expected_topic TEXT,
  mood_score INTEGER,
  what_learned TEXT,
  feedback TEXT,
  synced INTEGER DEFAULT 0,
  created_at TEXT NOT NULL
);
```

---

## 7. MVP Development Timeline (3 hours)

| Phase | Duration | Tasks |
|-------|----------|-------|
| **Setup** | 15 min | Create folder structure, add dependencies, initialize SQLite |
| **Core Services** | 30 min | LocationService, QrService, DatabaseService |
| **Models** | 10 min | Attendance & Reflection models |
| **Home Screen** | 20 min | Navigation hub with 3 buttons |
| **Check-in Screen** | 40 min | QR scanner, GPS retrieval, form validation, save |
| **Finish Class Screen** | 30 min | QR scanner, reflection form, save check-out |
| **Polish & Testing** | 15 min | UI refinement, error handling, basic testing |

---

## 8. Key Implementation Notes

✅ **MVP-First Approach:**
- Use Provider for lightweight state management
- SQLite for robust local storage
- No Firebase in MVP (add in Phase 2)
- Minimal UI polish (functionality first)

✅ **Permissions to Request:**
- Location (ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION)
- Camera (for QR scanning)

✅ **Error Handling:**
- GPS unavailable → fallback UI message
- QR scan failed → retry mechanism
- Database failure → local cache + retry on next sync

✅ **Testing Focus:**
- Happy path testing (successful check-in/out)
- Permission denial handling
- Offline data storage validation

---

**Next Steps:** 
1. Clone/generate folder structure
2. Add dependencies to pubspec.yaml
3. Run `flutter pub get`
4. Begin screen implementation (Home first)
