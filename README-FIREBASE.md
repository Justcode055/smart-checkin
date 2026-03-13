# Firebase Deployment Guide for Smart Class Check-in App

## Prerequisites
- Install Node.js and npm
- Install Firebase CLI: `npm install -g firebase-tools`
- A Google account to create Firebase projects

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Create a project"**
3. Enter project name: `flutter-smart-checkin` (or your preferred name)
4. Click **"Continue"**
5. Disable Google Analytics (optional) and click **"Create project"**
6. Wait for the project to be created

## Step 2: Set Up Firebase Hosting

1. In Firebase Console, go to **Build → Hosting**
2. Click **"Get Started"**
3. Follow the wizard to set up hosting
4. Your hosting URL will be: `https://YOUR_PROJECT_ID.web.app`

## Step 3: Configure Firebase CLI

```bash
# Navigate to your project directory
cd "c:\Users\LAB\Desktop\Midterm_Labtest\flutter_application_1"

# Login to Firebase
firebase login

# Initialize Firebase (if not already done)
firebase init hosting
```

When prompted:
- Select your project from the list
- Use `build/web` as the public directory
- Configure as single-page app: **YES**

## Step 4: Generate Firebase Configuration

Use FlutterFire CLI to automatically generate configuration:

```bash
# Install FlutterFire CLI globally
dart pub global activate flutterfire_cli

# Configure FlutterFire
flutterfire configure
```

Select your Firebase project when prompted. This will:
- Update `firebase_options.dart` with your credentials
- Update Android, iOS, and web configs automatically

## Step 5: Update Dependencies

```bash
# Get the latest packages
flutter pub get
```

## Step 6: Build for Web

```bash
# Clean previous builds
flutter clean

# Build the web version
flutter build web --web-renderer=html
```

Note: `--web-renderer=html` is recommended for better compatibility. If you need better performance, use `--web-renderer=canvaskit` instead.

## Step 7: Deploy to Firebase Hosting

```bash
# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## Step 8: Access Your App

Your app will be live at:
- Primary URL: `https://YOUR_PROJECT_ID.web.app`
- Secondary URL: `https://YOUR_PROJECT_ID.firebaseapp.com`

## Deployment Structure

The deployment uses this structure:
```
project/
├── build/web/          → Generated web build (deployed to Firebase)
├── firebase.json       → Firebase configuration
├── .firebaserc         → Firebase project mapping
├── lib/firebase_options.dart → Firebase credentials
└── pubspec.yaml        → Dependencies including Firebase
```

## Troubleshooting

### Issue: "Database operations not supported on web"
**Expected behavior** - The app gracefully skips database operations on web. Data is only stored locally on mobile/desktop.

### Issue: "No Firebase project found"
**Solution**: Make sure you've run `firebase login` and `flutterfire configure`

### Issue: Build fails with web renderer error
**Solution**: Try the HTML renderer:
```bash
flutter build web --web-renderer=html
```

### Issue: Deploy fails with "Hosting not configured"
**Solution**: Go to Firebase Console → Build → Hosting and enable Hosting

## After Deployment

### Redeploy Updates
```bash
flutter build web --release
firebase deploy --only hosting
```

### Monitor Hosting
- Visit Firebase Console → Build → Hosting
- View deployment history and analytics

### Custom Domain (Optional)
1. In Firebase Hosting, click **"Connect domain"**
2. Follow the domain connection wizard
3. Configure DNS records as provided

## Environment Variables

For sensitive data, consider using:
- Firebase Realtime Database
- Cloud Firestore
- Firebase Storage

These are handled through Firebase Security Rules, not environment variables.

## Notes

- **Web-only** deployment: Database operations (SQLite) don't work on web
- **Mobile/Desktop** deployment: Full features including local database
- **Data sync**: Consider Firebase Firestore or Realtime Database for cross-device sync
- **Authentication**: Add Firebase Auth if user login is needed

## Next Steps

1. Test the app at your Firebase URL
2. Configure custom domain (optional)
3. Set up Firebase Analytics for usage tracking
4. Add Firebase Security Rules for Firestore/Realtime Database
5. Consider adding user authentication with Firebase Auth

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Integration](https://firebase.flutter.dev/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)
