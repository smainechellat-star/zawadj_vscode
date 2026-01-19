# Firebase Setup Guide for ZAWADJ App

This guide will help you configure Firebase for the ZAWADJ marriage application.

## Prerequisites

- A Google account
- Flutter installed on your machine
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project" or select an existing project
3. Enter project name (e.g., "zawadj-app")
4. Follow the setup wizard

## Step 2: Enable Firebase Services

In your Firebase Console, enable the following services:

### Authentication
1. Go to **Authentication** → **Sign-in method**
2. Enable the following providers:
   - ✅ **Email/Password** (Required)
   - ✅ **Google** (Required - see Google Sign-In setup below)
   - ✅ **Phone** (Optional - for SMS OTP)
   - ✅ **Facebook** (Optional - see Facebook Login setup below)

### Cloud Firestore
1. Go to **Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development) or **production mode**
4. Choose a location close to your users

### Firebase Storage
1. Go to **Storage**
2. Click "Get started"
3. Use default security rules or customize as needed

### Cloud Messaging (Optional)
1. Go to **Cloud Messaging**
2. Enable the service for push notifications

## Step 3: Configure Firebase for Flutter

### Option A: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI (if not already installed)
dart pub global activate flutterfire_cli

# Navigate to your project directory
cd /path/to/zawadj_vscode

# Configure Firebase
flutterfire configure --project=your-firebase-project-id
```

This command will:
- Create/update `lib/firebase_options.dart`
- Generate `android/app/google-services.json`
- Generate `ios/Runner/GoogleService-Info.plist`

### Option B: Manual Configuration

#### Android Setup

1. In Firebase Console, click the Android icon to add an Android app
2. Enter package name: `com.example.zawadj`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`
5. **DO NOT commit this file to git** (already in .gitignore)

#### iOS Setup

1. In Firebase Console, click the iOS icon to add an iOS app
2. Enter bundle ID: `com.example.zawadj`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/GoogleService-Info.plist`
5. **DO NOT commit this file to git** (already in .gitignore)

#### Update firebase_options.dart

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration values.

## Step 4: Configure Google Sign-In

### Android
1. Get your SHA-1 and SHA-256 fingerprints:
   ```bash
   # Debug certificate
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # Release certificate (if you have one)
   keytool -list -v -keystore /path/to/your/release.keystore -alias your-alias
   ```

2. In Firebase Console → Project Settings → Your Android App:
   - Add SHA-1 and SHA-256 fingerprints
   - Download the updated `google-services.json`

3. In Google Cloud Console:
   - Enable **Google+ API**
   - Configure OAuth consent screen

### iOS
1. Copy the `REVERSED_CLIENT_ID` from `GoogleService-Info.plist`
2. Add it to your iOS URL schemes in Xcode

### Common Issues
- **Error: "sign_in_failed"** → SHA-1/SHA-256 not configured properly
- **Error: "10"** → OAuth client not properly set up in Google Cloud Console

## Step 5: Configure Facebook Login (Optional)

1. Create a Facebook App at [Facebook Developers](https://developers.facebook.com/)
2. Add Facebook Login product
3. Get your App ID and App Secret
4. In Firebase Console → Authentication → Facebook:
   - Enable Facebook provider
   - Enter your App ID and App Secret
5. Add Facebook configuration to your app:

### Android
Update `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data 
    android:name="com.facebook.sdk.ApplicationId" 
    android:value="@string/facebook_app_id"/>

<activity 
    android:name="com.facebook.FacebookActivity"
    android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
    android:label="@string/app_name" />
```

Create `android/app/src/main/res/values/strings.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">ZAWADJ</string>
    <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
    <string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
</resources>
```

### iOS
Update `ios/Runner/Info.plist` with Facebook configuration.

## Step 6: Test Your Configuration

1. Run the app on a device or emulator
2. Try registering with email/password
3. Try signing in with Google (if configured)
4. Check Firebase Console to see if users are created

## Security Rules

### Firestore Rules (Development)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read all users (for matching)
    match /users/{userId} {
      allow read: if request.auth != null;
    }
    
    // Contact messages - write only
    match /contact_messages/{messageId} {
      allow create: if request.auth != null;
      allow read, update, delete: if false; // Only admins can read
    }
  }
}
```

### Storage Rules (Development)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user_photos/{userId}/{fileName} {
      // Allow authenticated users to upload their own photos
      allow write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null;
    }
  }
}
```

## Troubleshooting

### Common Errors

1. **"Unknown error - An internal error has occurred (configuration not found)"**
   - Cause: `firebase_options.dart` not properly configured
   - Solution: Run `flutterfire configure` or manually update the file

2. **"PlatformException (sign_in_failed)"**
   - Cause: Google Sign-In not properly configured
   - Solution: Add SHA-1/SHA-256 fingerprints to Firebase Console

3. **"MissingPluginException"**
   - Cause: Plugin not properly registered
   - Solution: Run `flutter clean && flutter pub get`

4. **"Operation not allowed"**
   - Cause: Authentication provider not enabled in Firebase
   - Solution: Enable the provider in Firebase Console

## Production Checklist

Before deploying to production:

- [ ] Update Firestore security rules
- [ ] Update Storage security rules
- [ ] Enable App Check for additional security
- [ ] Set up proper error tracking (Firebase Crashlytics)
- [ ] Generate release signing keys
- [ ] Test all authentication methods
- [ ] Set up password reset email templates
- [ ] Configure email verification settings
- [ ] Review and test security rules thoroughly

## Support

For issues specific to:
- Firebase: [Firebase Support](https://firebase.google.com/support)
- Flutter: [Flutter Documentation](https://flutter.dev/docs)
- This app: Create an issue in the repository

## Important Notes

⚠️ **Never commit these files to version control:**
- `google-services.json`
- `GoogleService-Info.plist`
- `firebase_options.dart` (if it contains real keys)
- Any file with API keys or secrets

✅ These files are already in `.gitignore` for your safety.
