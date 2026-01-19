# Developer Setup Instructions

This document provides quick setup instructions for developers working on the ZAWADJ app.

## Prerequisites

- Flutter SDK (3.10.7 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project (see FIREBASE_SETUP.md)
- FlutterFire CLI: `dart pub global activate flutterfire_cli`

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/smainechellat-star/zawadj_vscode.git
cd zawadj_vscode
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase (REQUIRED)

The app will not work without proper Firebase configuration. Follow these steps:

#### Option A: Automatic Configuration (Recommended)

```bash
# Make sure you have FlutterFire CLI installed
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=your-firebase-project-id
```

This will automatically:
- Update `lib/firebase_options.dart` with your project settings
- Generate `android/app/google-services.json`
- Generate `ios/Runner/GoogleService-Info.plist`

#### Option B: Manual Configuration

If you prefer manual configuration, follow the detailed instructions in [FIREBASE_SETUP.md](FIREBASE_SETUP.md).

### 4. Enable Firebase Services

In your Firebase Console, enable:
- ✅ Authentication (Email/Password, Google, Facebook)
- ✅ Cloud Firestore
- ✅ Firebase Storage
- ✅ Cloud Messaging (optional)

### 5. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

## Project Structure

```
zawadj_vscode/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── firebase_options.dart     # Firebase configuration (auto-generated)
│   ├── models/                   # Data models
│   ├── screens/                  # UI screens
│   │   ├── authentication_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── partner_criteria_screen.dart
│   │   ├── photo_upload_screen.dart
│   │   └── ...
│   ├── services/                 # Business logic & API calls
│   │   ├── auth_service.dart
│   │   ├── social_auth_service.dart
│   │   └── password_auth_service.dart
│   ├── providers/                # State management
│   ├── widgets/                  # Reusable widgets
│   ├── utils/                    # Utilities & constants
│   └── l10n/                     # Localization (Arabic/English)
├── android/                      # Android-specific code
├── ios/                          # iOS-specific code
├── FIREBASE_SETUP.md            # Detailed Firebase setup guide
└── pubspec.yaml                 # Dependencies
```

## Key Features Implemented

### Authentication
- ✅ Email/Password registration and login
- ✅ Google Sign-In
- ✅ Facebook Login (requires setup)
- ✅ Phone authentication (SMS OTP)
- ⚠️ Instagram/TikTok (marked as "under development")

### User Profile
- ✅ Personal information (name, age, gender, location)
- ✅ Social information (education, employment, housing)
- ✅ Physical appearance (height, skin color, body type)
- ✅ Data saved to Cloud Firestore
- ✅ Data loaded when screen opens

### Partner Criteria
- ✅ Age range preference
- ✅ Location preferences (country, state)
- ✅ Marital status, education, appearance preferences
- ✅ Additional criteria (smoking, prayer, etc.)
- ✅ Data saved to Firestore
- ✅ Data loaded when screen opens

### Photo Upload
- ✅ Image picker integration
- ✅ Upload to Firebase Storage
- ✅ Progress tracking
- ✅ Photo URL saved to Firestore
- ✅ Photo visibility toggle

### Statistics
- ✅ Real-time user statistics from Firestore
- ✅ User status counts (available, married, etc.)
- ✅ Percentage calculations

### Contact
- ✅ Message submission to Firestore
- ✅ Form validation
- ✅ Email integration

## Common Issues & Solutions

### Issue: "configuration not found" error

**Solution:** Run `flutterfire configure` to generate proper Firebase configuration files.

### Issue: Google Sign-In fails with "sign_in_failed"

**Solution:** 
1. Get your SHA-1 and SHA-256 fingerprints
2. Add them to Firebase Console → Project Settings → Your App
3. Download updated `google-services.json`

### Issue: Facebook Login shows "MissingPluginException"

**Solution:** 
1. Configure Facebook App in Facebook Developers Console
2. Add Facebook App ID to AndroidManifest.xml
3. Enable Facebook provider in Firebase Console

### Issue: Photo upload fails

**Solution:** 
1. Check camera/storage permissions in AndroidManifest.xml (already added)
2. Verify Firebase Storage is enabled
3. Check Storage security rules

## Development Workflow

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Format Code

```bash
flutter format lib/
```

## Firebase Security Rules

### Firestore (Development)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /contact_messages/{messageId} {
      allow create: if request.auth != null;
    }
  }
}
```

### Storage (Development)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user_photos/{userId}/{fileName} {
      allow write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null;
    }
  }
}
```

## Important Notes

⚠️ **Never commit these files:**
- `google-services.json`
- `GoogleService-Info.plist`
- `lib/firebase_options.dart` (if it contains real keys)

These files are in `.gitignore` for security.

✅ **Template files are committed:**
- `lib/firebase_options.dart` (template with placeholder values)

## Support & Documentation

- **Firebase Setup:** See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- **Flutter Docs:** https://flutter.dev/docs
- **Firebase Docs:** https://firebase.google.com/docs

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

[Add your license information here]
