# ZAWADJ - Islamic Marriage Application

A comprehensive Flutter-based marriage application designed for the Muslim community, featuring advanced authentication, partner matching, and communication systems.

## 🎯 Project Overview

ZAWADJ is a modern dating/marriage application that respects Islamic values and traditions while leveraging cutting-edge mobile technology. The app facilitates halal connections between Muslims looking for marriage through intelligent matching algorithms, secure authentication, and privacy-focused communication features.

---

## 📁 Application Structure

```
zawadj_vscode/
│
├── lib/
│   ├── main.dart                          # Application entry point
│   │
│   ├── screens/                           # UI Screens
│   │   ├── splash_screen.dart             # Initial loading screen
│   │   ├── authentication_screen.dart     # Login/Register with multiple methods
│   │   ├── forgot_password_screen.dart    # Password recovery
│   │   ├── home_screen.dart               # Main dashboard
│   │   ├── profile_screen.dart            # User profile management
│   │   ├── search_screen.dart             # Partner discovery with swipe
│   │   ├── partner_preview_screen.dart    # Detailed partner profile view
│   │   ├── partner_criteria_screen.dart   # Match preferences settings
│   │   ├── chat_screen.dart               # One-on-one messaging
│   │   ├── photo_upload_screen.dart       # Profile photo management
│   │   ├── settings_screen.dart           # App configuration
│   │   ├── statistics_screen.dart         # User activity analytics
│   │   ├── terms_screen.dart              # Terms and conditions
│   │   ├── about_screen.dart              # About the application
│   │   └── contact_screen.dart            # Support contact
│   │
│   ├── services/                          # Business Logic & APIs
│   │   ├── auth_service.dart              # OTP authentication service
│   │   ├── password_auth_service.dart     # Email/password authentication
│   │   ├── social_auth_service.dart       # Google/Facebook login
│   │   ├── chat_service.dart              # Message management
│   │   ├── captcha_service.dart           # Bot protection
│   │   └── local_storage_service.dart     # Local data persistence
│   │
│   ├── providers/                         # State Management (Provider)
│   │   ├── auth_provider.dart             # Authentication state
│   │   ├── language_provider.dart         # Localization state
│   │   └── user_provider.dart             # User data state
│   │
│   ├── models/                            # Data Models
│   │   ├── user_model.dart                # User entity
│   │   ├── chat_model.dart                # Chat & message entities
│   │   └── match_model.dart               # Partner match entity
│   │
│   ├── widgets/                           # Reusable UI Components
│   │   └── common_widgets.dart            # Buttons, text fields, app bars
│   │
│   ├── utils/                             # Utility Functions
│   │   └── constants.dart                 # App constants & configurations
│   │
│   ├── l10n/                              # Localization
│   │   ├── arabic_strings.dart            # Arabic translations
│   │   └── english_strings.dart           # English translations
│   │
│   └── firebase_options.dart              # Firebase configuration
│
├── android/                               # Android-specific code
├── ios/                                   # iOS-specific code
├── web/                                   # Web support files
├── assets/                                # Images, fonts, etc.
│
├── pubspec.yaml                           # Dependencies & project config
├── README.md                              # This file
└── AUTHENTICATION_UPDATES.md              # Auth features documentation

```

---

## 🔄 Application Flow & Algorithm

### 1. **Authentication Flow**

```
User Opens App
      ↓
Splash Screen (2s)
      ↓
Check Authentication Status
      ↓
   ┌──────────────┴──────────────┐
   ↓                             ↓
Authenticated              Not Authenticated
   ↓                             ↓
Home Screen            Authentication Screen
                              ↓
                    ┌─────────┼─────────┐
                    ↓         ↓         ↓
              Password    Google    Facebook
                Login     Login      Login
                    ↓         ↓         ↓
                    └─────────┼─────────┘
                              ↓
                    OTP/CAPTCHA Verification
                              ↓
                         Home Screen
```

**Authentication Methods:**
- **Password Authentication**: Email + strong password (8+ chars, mixed case, numbers, symbols)
- **Social Login**: Google OAuth & Facebook Login with automatic profile creation
- **OTP Verification**: Via Messenger, Telegram, Viber, or Instagram (SMS removed)
- **CAPTCHA**: Mathematical challenge for bot prevention
- **Password Reset**: Email-based recovery system

### 2. **Partner Matching Algorithm**

```
User Profile Data
      ↓
Extract Criteria:
  - Age Range
  - Location (City/Region)
  - Education Level
  - Religious Commitment
  - Marital Status
      ↓
Query Firebase Database
      ↓
Filter Candidates:
  1. Opposite Gender
  2. Age Range Match
  3. Location Proximity
  4. Religious Compatibility
      ↓
Calculate Compatibility Score:
  Score = Σ(Weight[i] × Match[i])
  
  Weights:
    - Religious Values: 35%
    - Location: 20%
    - Education: 15%
    - Age Compatibility: 15%
    - Shared Interests: 15%
      ↓
Sort by Score (Descending)
      ↓
Present Top Matches
```

### 3. **Search & Discovery Flow**

```
User Opens Search Screen
      ↓
Load Matched Partners (sorted by compatibility)
      ↓
Display Partner Card
      ↓
User Interactions:
  ┌─────────┼─────────┐
  ↓         ↓         ↓
Swipe    Tap Card   Buttons
  │         │         │
  ├─ Right→Left: Next
  ├─ Left→Right: Previous
  │         │         │
  │     Preview   ├─ Chat
  │     Screen    ├─ Message
  │         │     └─ Favorite
  │         ↓
  │    View Full Profile:
  │      - Personal ID
  │      - Social ID
  │      - Detailed Info
  │         ↓
  └────Action Buttons────┘
           ↓
    Update Match Status
           ↓
    Continue Browsing
```

### 4. **Chat System Architecture**

```
User A selects User B
      ↓
Generate Chat Room ID: sorted(UserA_ID + UserB_ID)
      ↓
Check Existing Chat Room
      ↓
   ┌──────────┴──────────┐
   ↓                     ↓
Exists              New Room
   ↓                     ↓
Load Messages      Create Room
   ↓                     ↓
   └──────────┬──────────┘
              ↓
Display Chat Interface
      ↓
User sends message
      ↓
Firebase Write:
  /chats/{chatId}/messages/{messageId}
      ↓
Real-time Listener Updates Both Users
      ↓
Display Message with:
  - Sender identification
  - Timestamp
  - Read status
      ↓
3-Day Trial Period
      ↓
After 3 Days → Connection Request Options:
  - Request Guardian Phone
  - Request Personal Phone
  - Request Social Media
      ↓
Mutual Consent Required for Contact Info Exchange
```

### 5. **Privacy & Security Protocol**

```
User Registration
      ↓
Data Encryption:
  - Password → SHA-256 Hash
  - Personal Info → AES Encryption
      ↓
Store in Firebase Firestore
      ↓
Profile Visibility Rules:
  - Photos: Blurred until match
  - Phone: Hidden (request-based)
  - Location: City only (not exact)
  - Name: First name only initially
      ↓
Match Established
      ↓
Limited Information Shared:
  - First Name
  - Age
  - City
  - Compatibility Score
      ↓
3-Day Communication Period
      ↓
Connection Request Phase
      ↓
Mutual Approval Required
      ↓
Full Contact Exchange:
  - Guardian Contact (Optional)
  - Personal Phone
  - Social Media Links
      ↓
Continued Monitoring for Safety
```

---

## 🧩 Core Features & Algorithms

### **1. Compatibility Score Calculation**

```dart
double calculateCompatibilityScore(User currentUser, User candidate) {
  double score = 0.0;
  
  // Religious Compatibility (35%)
  if (currentUser.religiousLevel == candidate.religiousLevel) {
    score += 35.0;
  } else if (abs(currentUser.religiousLevel - candidate.religiousLevel) <= 1) {
    score += 25.0;
  }
  
  // Location Proximity (20%)
  if (currentUser.city == candidate.city) {
    score += 20.0;
  } else if (currentUser.region == candidate.region) {
    score += 12.0;
  }
  
  // Education Level (15%)
  if (currentUser.educationLevel == candidate.educationLevel) {
    score += 15.0;
  } else if (abs(currentUser.educationLevel - candidate.educationLevel) <= 1) {
    score += 10.0;
  }
  
  // Age Compatibility (15%)
  int ageDifference = abs(currentUser.age - candidate.age);
  if (ageDifference <= 3) {
    score += 15.0;
  } else if (ageDifference <= 5) {
    score += 10.0;
  } else if (ageDifference <= 8) {
    score += 5.0;
  }
  
  // Shared Interests (15%)
  int commonInterests = currentUser.interests
      .toSet()
      .intersection(candidate.interests.toSet())
      .length;
  score += (commonInterests / currentUser.interests.length) * 15.0;
  
  return score;
}
```

### **2. Swipe Gesture Detection**

```dart
GestureDetector(
  onHorizontalDragEnd: (details) {
    // Calculate swipe velocity
    if (details.primaryVelocity! < -500) {
      // Fast swipe right to left → Next partner
      moveToNext();
    } else if (details.primaryVelocity! > 500) {
      // Fast swipe left to right → Previous partner
      moveToPrevious();
    }
  },
  child: PartnerCard(...)
)
```

### **3. Real-Time Chat Synchronization**

```dart
Stream<List<Message>> getMessages(String chatId) {
  return FirebaseFirestore.instance
    .collection('chats')
    .doc(chatId)
    .collection('messages')
    .orderBy('timestamp', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromFirestore(doc))
        .toList());
}
```

### **4. CAPTCHA Verification**

```dart
Map<String, dynamic> generateMathCaptcha() {
  final operations = ['+', '-', '×'];
  final operation = operations[Random().nextInt(3)];
  final num1 = Random().nextInt(30) + 1;
  final num2 = Random().nextInt(30) + 1;
  
  int answer;
  switch (operation) {
    case '+': answer = num1 + num2; break;
    case '-': answer = num1 - num2; break;
    case '×': answer = num1 * num2; break;
  }
  
  return {
    'question': '$num1 $operation $num2 = ?',
    'answer': answer.toString()
  };
}
```

---

## 🗄️ Database Schema (Firestore)

### **Users Collection**
```javascript
users/{userId}
  ├── personalId: string          // Unique identifier
  ├── socialId: string             // Social media handle
  ├── email: string
  ├── firstName: string
  ├── lastName: string
  ├── age: number
  ├── gender: string
  ├── city: string
  ├── region: string
  ├── religiousLevel: number (1-5)
  ├── educationLevel: number (1-5)
  ├── maritalStatus: string
  ├── interests: array
  ├── photoURL: string
  ├── authMethod: string
  ├── createdAt: timestamp
  └── lastActive: timestamp
```

### **Chats Collection**
```javascript
chats/{chatId}
  ├── participants: [userId1, userId2]
  ├── createdAt: timestamp
  ├── lastMessage: string
  ├── lastMessageTime: timestamp
  ├── lastMessageSenderId: string
  └── messages/{messageId}
      ├── senderId: string
      ├── receiverId: string
      ├── message: string
      ├── timestamp: timestamp
      └── read: boolean
```

### **Matches Collection**
```javascript
matches/{matchId}
  ├── userId: string
  ├── matchedUserId: string
  ├── compatibilityScore: number
  ├── status: string (pending/accepted/rejected)
  ├── createdAt: timestamp
  └── expiresAt: timestamp
```

### **Connection Requests Collection**
```javascript
connectionRequests/{requestId}
  ├── senderId: string
  ├── receiverId: string
  ├── type: string (guardian/phone/social)
  ├── status: string (pending/approved/declined)
  ├── senderInfo: string (optional)
  └── createdAt: timestamp
```

---

## 🔧 Tech Stack

### **Frontend**
- **Framework**: Flutter 3.38.6
- **Language**: Dart 3.10.7
- **State Management**: Provider 6.1.0
- **UI Components**: Material Design 3

### **Backend & Services**
- **Authentication**: Firebase Auth 4.16.0
- **Database**: Cloud Firestore 4.13.0
- **Storage**: Firebase Storage 11.5.0
- **Push Notifications**: Firebase Messaging 14.7.0
- **Social Login**: 
  - Google Sign-In 6.1.5
  - Facebook Auth 6.0.3

### **Security**
- **Password Encryption**: crypto 3.0.3 (SHA-256)
- **CAPTCHA**: Custom mathematical challenges
- **Data Validation**: Built-in validators

### **Other Dependencies**
- **HTTP Client**: dio 5.4.0
- **Local Storage**: shared_preferences 2.2.0, sqflite 2.3.0
- **Image Handling**: image_picker 1.0.0, cached_network_image 3.3.0
- **Routing**: go_router 12.0.0
- **Localization**: flutter_localizations (SDK), intl 0.20.2

---

## 🚀 Getting Started

### Prerequisites
```bash
Flutter SDK: 3.38.6+
Dart SDK: 3.10.7+
Android Studio / VS Code
Firebase Account
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/zawadj_vscode.git
cd zawadj_vscode
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Create a Firebase project
- Download `google-services.json` → `android/app/`
- Download `GoogleService-Info.plist` → `ios/Runner/`
- Enable Authentication methods (Email, Google, Facebook)
- Create Firestore database

4. **Configure Social Login**

**Google Sign-In:**
```bash
# Get SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey
# Add to Firebase Console
```

**Facebook Login:**
- Create app on Facebook Developers
- Add Facebook App ID to `android/app/src/main/res/values/strings.xml`

5. **Run the app**
```bash
flutter run
```

### Build APK
```bash
flutter build apk --release
```

---

## 📱 App Permissions

### Android (`AndroidManifest.xml`)
- `INTERNET` - Network communication
- `CAMERA` - Profile photo capture
- `READ_EXTERNAL_STORAGE` - Photo selection
- `WRITE_EXTERNAL_STORAGE` - Photo saving
- `ACCESS_NOTIFICATION` - Push notifications

### iOS (`Info.plist`)
- `NSCameraUsageDescription` - Camera access
- `NSPhotoLibraryUsageDescription` - Photo library access
- `NSLocationWhenInUseUsageDescription` - Location services

---

## 🔐 Security Features

1. **Authentication Security**
   - Multi-factor authentication options
   - Strong password requirements
   - SHA-256 password hashing
   - OAuth 2.0 for social login
   - CAPTCHA bot protection

2. **Data Privacy**
   - End-to-end message encryption (planned)
   - Minimal data exposure
   - Guardian-based contact approval
   - 3-day trial communication period
   - Reversible blocking/reporting

3. **Profile Protection**
   - Photo blur until match approval
   - Limited initial information disclosure
   - Request-based contact info sharing
   - Mutual consent requirements

---

## 📄 Documentation

- [Authentication Updates](AUTHENTICATION_UPDATES.md) - Detailed auth features (Arabic/English)
- [Implementation Guide](IMPLEMENTATION_GUIDE_DETAILED.md) - Complete development guide
- [CAPTCHA Guide](CAPTCHA_AUTH_GUIDE.md) - CAPTCHA system documentation

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For issues, questions, or feature requests:
- **Email**: support@zawadj.com
- **GitHub Issues**: [Project Issues](https://github.com/yourusername/zawadj_vscode/issues)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Flutter & Dart teams
- Firebase team
- Islamic community for guidance
- All contributors and testers

---

**Version**: 1.1.0  
**Last Updated**: January 18, 2026  
**Developer**: ZAWADJ Development Team
