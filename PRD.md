# Product Requirement Document (PRD)
## Smart Class Check-in & Learning Reflection App

**Version:** 1.0 | **Date:** March 2026 | **Status:** MVP

---

## 1. Problem Statement

Universities struggle to:
- **Verify physical attendance** in real-time with location-based confirmation
- **Measure learning engagement** through structured reflection before and after classes
- **Track student sentiment** about learning progress and teaching quality

The Smart Class Check-in & Learning Reflection App solves this by automating attendance verification and capturing meaningful learning data through reflective assessments.

---

## 2. Target Users

| User | Purpose |
|------|---------|
| **Students** | Check in/out of class, complete learning reflections, track their mood and learning |
| **Instructors** | Monitor real-time attendance, view class participation metrics |
| **University Admins** | Access aggregated data on attendance and learning trends |

---

## 3. Key Features

### Core Features (MVP)
1. **Pre-Class Check-in**
   - QR code scan
   - GPS location recording
   - Timestamp capture
   
2. **Pre-Class Reflection Form**
   - Topic from previous class
   - Expected topic today
   - Mood score (1–5)
   
3. **Post-Class Check-out**
   - QR code scan
   - Timestamp capture
   
4. **Post-Class Reflection Form**
   - What they learned today
   - Feedback for class/instructor
   
5. **Local Data Storage**
   - SQLite database for offline-first functionality
   - Reflection & attendance records stored locally

6. **Future: Firebase Integration**
   - Cloud sync capability
   - Aggregated analytics dashboard

---

## 4. User Flow

```
Student → QR Check-in → GPS Recorded → Pre-Class Reflection 
→ [Attend Class] → QR Check-out → Post-Class Reflection → Data Saved Locally
```

**Offline Capability:** All data syncs locally; cloud sync optional in future versions.

---

## 5. Data Fields

### Pre-Class Reflection
- `student_id` (UUID)
- `class_id` (UUID)
- `check_in_time` (DateTime)
- `gps_latitude`, `gps_longitude` (Double)
- `qr_code_data` (String)
- `previous_topic` (String)
- `expected_topic` (String)
- `mood_score` (1–5 Int)

### Post-Class Reflection
- `student_id` (UUID)
- `class_id` (UUID)
- `check_out_time` (DateTime)
- `qr_code_data` (String)
- `what_learned` (String, max 500 chars)
- `feedback_text` (String, max 500 chars)
- `synced_to_firebase` (Boolean, default: false)

---

## 6. Tech Stack

| Component | Technology |
|-----------|-----------|
| **Frontend** | Flutter (iOS + Android) |
| **Local Database** | SQLite via `sqflite` package |
| **Backend (Future)** | Firebase Realtime Database / Firestore |
| **Authentication** | Student ID + QR codes (later: Firebase Auth) |
| **Location Services** | Geolocator package |
| **QR Scanning** | QR Code Scanner package |

---

## 7. MVP Scope

### In Scope ✅
- Mobile first (iOS & Android)
- QR code check-in/out
- GPS location recording at check-in
- Pre & post-class reflection forms
- SQLite local storage
- Offline-first functionality
- Basic UI/UX for student workflow

### Out of Scope ❌
- Instructor dashboard (Phase 2)
- Analytics dashboard (Phase 2)
- Firebase integration (Phase 2)
- Admin portal (Phase 3)
- Learning analytics ML models (Future)
- SSO integration (Phase 2)

---

## Success Metrics (MVP)
- ✅ 100% of students can complete check-in within 2 minutes
- ✅ Reflection form completion rate: > 80%
- ✅ GPS accuracy within campus boundaries (±50m)
- ✅ Zero data loss with local SQLite storage
- ✅ App launches in < 2 seconds on average device

---

**Next Steps:** Finalize UI mockups → Backend API design → Development sprint planning
