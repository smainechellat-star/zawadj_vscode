# ZAWADJ - Islamic Marriage Application

## 📱 Overview

ZAWADJ is a comprehensive Flutter application designed for Islamic matrimonial networking. The app focuses on serious matchmaking with robust safety features, privacy controls, and Sharia-compliant communication standards.

**Developed for**: Android devices
**Version**: 2026
**Language Support**: Arabic & English
**Developer**: Smaine Chellat

---

## 🎯 Core Features

### 1. **Authentication & Onboarding**
- Splash screen with welcome message
- Phone number-based registration with OTP verification
- Language selection (Arabic/English)
- Automatic user session management

### 2. **User Profile Management**
- Comprehensive personal information collection
- Physical appearance details
- Social and employment information
- Support for multi-marriage scenarios
- Profile completeness tracking

### 3. **Partner Matching System**
- Smart compatibility algorithm based on:
  - Age (15 points)
  - Geographic location (20 points)
  - Education level (15 points)
  - Marital status (15 points)
  - Height (10 points)
  - Income/Employment (10 points)
- Multi-select criteria filtering
- Real-time matching recommendations

### 4. **Account Status System**
- **Available** (💚 Green): Active and searching
- **In Serious Process** (🧡 Orange): In mutual discussion (30-day lock)
- **Married** (❤️ Red): Successfully matched
- **Withdrawn** (🖤 Black): User exit

### 5. **Communication Features**
- In-app chat messaging
- 3-day initial communication period
- Contact information sharing requests:
  - Guardian/Wali phone number
  - Personal phone number
  - Social media handles
- Bilateral approval system
- Automatic blocking after rejection
- 48-hour re-request cooldown

### 6. **Safety & Privacy**
- Photo approval system with review process
- Screen capture prevention
- Real selfie verification
- Respectful clothing requirements
- User discretion controls (show/hide profile)
- Account deletion with safety period (7/14/30 days)
- Account archiving option

### 7. **Statistics Dashboard**
- Total registered users
- Available/active users
- Users in serious process
- Successfully married couples
- Withdrawn users

### 8. **Settings & Preferences**
- Multi-language support (AR/EN)
- Profile editing
- Partner criteria modification
- Terms & conditions acceptance
- Privacy policy
- Account management
- Contact support

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point with routing
├── models/                            # Data models
│   ├── enums.dart                    # All enumeration types
│   ├── user_model.dart               # User profile model
│   ├── partner_criteria_model.dart    # Partner criteria model
│   └── chat_model.dart               # Chat & connection models
├── services/                          # Business logic services
│   ├── auth_service.dart             # Authentication service
│   ├── chat_service.dart             # Chat & messaging service
│   ├── search_service.dart           # Matching algorithm service
│   └── local_storage_service.dart    # Local storage management
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart            # Auth state
│   ├── language_provider.dart        # Language preferences
│   └── user_provider.dart            # User profile state
├── screens/                           # UI screens
│   ├── splash_screen.dart            # Initial splash
│   ├── authentication_screen.dart    # Login/Register
│   ├── home_screen.dart              # Main dashboard
│   ├── profile_screen.dart           # Profile editing
│   ├── partner_criteria_screen.dart  # Criteria setting
│   ├── terms_screen.dart             # Terms acceptance
│   ├── photo_upload_screen.dart      # Photo management
│   ├── search_screen.dart            # Auto-search results
│   ├── chat_screen.dart              # Messaging
│   ├── settings_screen.dart          # Settings menu
│   ├── statistics_screen.dart        # App statistics
│   ├── about_screen.dart             # About app
│   └── contact_screen.dart           # Contact support
├── widgets/                           # Reusable widgets
│   └── common_widgets.dart           # AppBar, Button, TextField, etc.
├── l10n/                              # Localization strings
│   ├── arabic_strings.dart           # Arabic translations
│   └── english_strings.dart          # English translations
└── utils/                             # Utilities
    └── constants.dart                # App constants, data lists
```

---

## 🔄 User Flow Diagram

```
Splash Screen
    ↓
[Logged In?] → Yes → Home Screen
    ↓
   No
    ↓
Authentication Screen (Login/Register)
    ↓
[First Time?] → Yes → Profile Setup Flow
    ↓              
  No → Home Screen
```

### Profile Setup Flow (New Users):
```
Profile Screen → Partner Criteria Screen → Terms & Conditions → Photo Upload → Home Screen
```

### User Features After Login:
```
Home Screen
    ├→ Profile Editing
    ├→ Auto Search (with match cards)
    ├→ Inbox (Chat/Messages)
    ├→ Settings
    │   ├→ Profile Management
    │   ├→ Criteria Setting
    │   ├→ Language Settings
    │   ├→ Statistics
    │   ├→ About App
    │   ├→ Contact Support
    │   ├→ Delete Account
    │   └→ Logout
    └→ Bottom Navigation (4 items)
```

---

## 📋 User Profile Data Structure

### Basic Information (Mandatory)
- First Name / Nickname
- Age (18-100)
- Gender (Male/Female)
- Country (All countries)
- State/City (Algerian cities)
- Marital Status
- Number of Children (if applicable)
- Children's Age Range
- Marriage Intent (1st, 2nd, 3rd, 4th time)

### Social Information (Mandatory)
- Education Level
- Employment Status
- Housing Type
- Alcohol/Drugs Use
- Smoking Status
- Prayer Habits

### Physical Appearance
- Glasses Status
- Height (100-200 cm)
- Skin Color
- Body Type

---

## 🎨 Compatibility Algorithm

### Scoring System (Total: 100 Points)

| Factor | Points | Calculation |
|--------|--------|-------------|
| Age | 15 | Based on proximity |
| Location | 20 | Same country/state |
| Education | 15 | Level proximity |
| Marital Status | 15 | Compatibility match |
| Height | 10 | cm difference |
| Income | 10 | Employment category |

### Score Interpretation
- 80-100: Excellent Match
- 60-79: Good Match
- 40-59: Moderate Match
- Below 40: Low Match

---

## 💬 Chat System Features

### Message Types
1. **Text Messages**: In-app messaging only
2. **Connection Requests**: After 3-day period
3. **Contact Sharing**: Phone, email, social media

### Timeline
- **Days 1-3**: Text chat only
- **After Day 3**: Contact sharing options
- **Bilateral Approval**: Both must accept
- **Duration**: 30-day maximum serious process
- **Extension**: Possible with mutual consent

### Auto-Blocking Rules
- Declined request: 48-hour cooldown
- Reserved account: Automatic filtering
- Withdrawn account: Invisible
- Multiple refusals: Permanent block

---

## 🔐 Security & Privacy Features

### Photo Security
- Admin review before publishing
- Real selfie verification
- Screen capture prevention (attempted)
- Show/hide controls
- One-time upload policy
- Archive after deletion

### Data Protection
- Phone numbers hidden until mutual approval
- Personal information encrypted
- Auto-delete messages option
- Account deletion with grace period
- GDPR-compliant data handling

### Content Moderation
- Automatic inappropriate content detection
- Admin manual review
- User reporting system
- Account suspension for violations

---

## 🌐 Localization

### Supported Languages
- **Arabic (AR)** - Primary language
- **English (EN)** - Secondary language

### Implemented Strings
- 200+ Arabic translations
- 200+ English translations
- Dynamic language switching without restart

### UI Adjustments for RTL
- Right-to-left layout for Arabic
- Left-to-right layout for English
- Directional icons and buttons

---

## 📦 Dependencies

### Core Flutter
- `flutter`: ^3.10.7
- `flutter_localizations`: For i18n
- `cupertino_icons`: ^1.0.8

### State Management
- `provider`: ^6.1.0

### Networking
- `http`: ^1.1.0

### Local Storage
- `shared_preferences`: ^2.2.0
- `hive`: ^2.2.3 & `hive_flutter`: ^1.1.0
- `sqflite`: ^2.3.0

### Firebase (Real-time features)
- `firebase_core`: ^2.24.0
- `firebase_auth`: ^4.14.0
- `cloud_firestore`: ^4.13.0
- `firebase_storage`: ^11.5.0
- `firebase_messaging`: ^14.7.0

### UI/UX
- `image_picker`: ^1.0.0
- `cached_network_image`: ^3.3.0
- `font_awesome_flutter`: ^10.7.0
- `pin_code_fields`: ^8.0.0
- `animations`: ^2.0.0

### Notifications
- `flutter_local_notifications`: ^16.3.0

### Routing
- `go_router`: ^12.0.0

### Utilities
- `uuid`: ^4.0.0
- `fluttertoast`: ^8.2.0
- `intl`: ^0.19.0

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK: ^3.10.7
- Android SDK: Minimum API 21
- Dart: Latest version

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zawadj_vscode
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files** (if using auto-generated i18n)
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release
```bash
flutter build apk --split-per-abi
```

---

## 🧪 Testing Checklist

### Authentication Flow
- [ ] Splash screen appears on startup
- [ ] Language selection works
- [ ] Phone registration with OTP
- [ ] Login with existing credentials
- [ ] Remember user preference
- [ ] Logout clears session

### Profile Setup
- [ ] All fields are mandatory on first registration
- [ ] Age, country, state dropdowns work
- [ ] Multi-select fields function correctly
- [ ] Navigation between screens works
- [ ] Data persistence between screens

### Search & Matching
- [ ] Compatibility score calculates correctly
- [ ] Match filtering works based on criteria
- [ ] Swipe/like/dislike functionality
- [ ] Connection requests send properly

### Chat
- [ ] Messages send and receive
- [ ] 3-day timer works
- [ ] Contact sharing requests appear after 3 days
- [ ] Bilateral approval system works
- [ ] Auto-blocking functionality

### Settings
- [ ] Language toggle changes UI
- [ ] Profile editing saves changes
- [ ] Criteria modification works
- [ ] Statistics load correctly
- [ ] Delete account dialog appears
- [ ] Logout redirects to auth screen

---

## 📈 Performance Optimization

1. **Image Caching**: Uses `cached_network_image`
2. **State Management**: Provider for efficient rebuilds
3. **Lazy Loading**: Chat messages load as needed
4. **Database Indexing**: Firestore queries optimized
5. **Bundle Optimization**: Code splitting for APK

---

## 🔗 API Integration Points

### Firebase Setup Required:
1. Google Cloud Project setup
2. Firebase Authentication
3. Cloud Firestore database
4. Firebase Storage
5. Firebase Cloud Messaging
6. Security rules configuration

### Mock Services for Development:
- AuthService: Mocked OTP verification
- ChatService: In-memory message storage
- SearchService: Algorithm implemented locally
- LocalStorageService: Using SharedPreferences

---

## 🛠️ Future Enhancements

1. **Video Chat**: Real-time video calling
2. **Voice Messages**: Audio messaging support
3. **Advanced Matching**: ML-based compatibility
4. **Report System**: User reporting interface
5. **Admin Panel**: Moderation dashboard
6. **Payment Integration**: Premium features
7. **Push Notifications**: Real-time alerts
8. **Read Receipts**: Message status indicators
9. **Typing Indicators**: Live typing notifications
10. **Profile Verification**: ID verification system

---

## 📞 Support & Contact

**Developer**: Smaine Chellat
**Email**: smaine.chellat@gmail.com

For bug reports, feature requests, or general inquiries, please contact via email.

---

## 📜 License

This application is proprietary software developed specifically for Islamic matrimonial networking. All rights reserved.

---

## ⚖️ Terms & Conditions

Users must agree to:
- Lawful marriage intentions only
- No outside-marriage relationships
- Truthful information provision
- No harassment or misuse
- Compliance with Islamic values

---

## 🙏 Acknowledgments

"This application has been developed to facilitate serious networking and lawful Islamic marriage."

May Allah bless this effort and grant us sincerity in all our deeds.

---

**Last Updated**: January 16, 2026
**App Version**: 2026
