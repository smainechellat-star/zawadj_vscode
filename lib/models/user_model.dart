import 'enums.dart';

class User {
  final String uid;
  final String firstName;
  final String? email;
  final String phoneNumber;
  final int age;
  final Gender gender;
  final String country;
  final String state;
  final MaritalStatus maritalStatus;
  final int? numberOfChildren;
  final ChildrenAgeRange? childrenAgeRange;
  final MarriageIntent marriageIntent;

  // Social Info
  final EducationLevel educationLevel;
  final EmploymentStatus employmentStatus;
  final HousingType housingType;
  final bool drinksAlcohol;
  final bool smokes;
  final PrayerStatus prayerStatus;

  // Physical Appearance
  final GlassesStatus wearGlasses;
  final int heightCm;
  final SkinColor skinColor;
  final BodyType bodyType;

  // Profile
  final String? profileImageUrl;
  final bool profileImageHidden;
  final bool profileComplete;

  // Status
  final AccountStatus accountStatus;
  final DateTime? accountStatusChangedAt;
  final String? partnerId; // ID of the person in serious process
  final DateTime? seriousProcessStartedAt;

  // Timestamps
  final DateTime createdAt;
  final DateTime lastUpdated;

  // Profile Views
  final List<String> viewedBy;

  User({
    required this.uid,
    required this.firstName,
    this.email,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.country,
    required this.state,
    required this.maritalStatus,
    this.numberOfChildren,
    this.childrenAgeRange,
    required this.marriageIntent,
    required this.educationLevel,
    required this.employmentStatus,
    required this.housingType,
    required this.drinksAlcohol,
    required this.smokes,
    required this.prayerStatus,
    required this.wearGlasses,
    required this.heightCm,
    required this.skinColor,
    required this.bodyType,
    this.profileImageUrl,
    this.profileImageHidden = true,
    this.profileComplete = false,
    this.accountStatus = AccountStatus.available,
    this.accountStatusChangedAt,
    this.partnerId,
    this.seriousProcessStartedAt,
    required this.createdAt,
    required this.lastUpdated,
    this.viewedBy = const [],
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender.toString(),
      'country': country,
      'state': state,
      'maritalStatus': maritalStatus.toString(),
      'numberOfChildren': numberOfChildren,
      'childrenAgeRange': childrenAgeRange?.toString(),
      'marriageIntent': marriageIntent.toString(),
      'educationLevel': educationLevel.toString(),
      'employmentStatus': employmentStatus.toString(),
      'housingType': housingType.toString(),
      'drinksAlcohol': drinksAlcohol,
      'smokes': smokes,
      'prayerStatus': prayerStatus.toString(),
      'wearGlasses': wearGlasses.toString(),
      'heightCm': heightCm,
      'skinColor': skinColor.toString(),
      'bodyType': bodyType.toString(),
      'profileImageUrl': profileImageUrl,
      'profileImageHidden': profileImageHidden,
      'profileComplete': profileComplete,
      'accountStatus': accountStatus.toString(),
      'accountStatusChangedAt': accountStatusChangedAt,
      'partnerId': partnerId,
      'seriousProcessStartedAt': seriousProcessStartedAt,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
      'viewedBy': viewedBy,
    };
  }

  // Create from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      firstName: map['firstName'] as String,
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String,
      age: map['age'] as int,
      gender: Gender.values.firstWhere((e) => e.toString() == map['gender']),
      country: map['country'] as String,
      state: map['state'] as String,
      maritalStatus: MaritalStatus.values.firstWhere(
        (e) => e.toString() == map['maritalStatus'],
      ),
      numberOfChildren: map['numberOfChildren'] as int?,
      childrenAgeRange: map['childrenAgeRange'] != null
          ? ChildrenAgeRange.values.firstWhere(
              (e) => e.toString() == map['childrenAgeRange'],
            )
          : null,
      marriageIntent: MarriageIntent.values.firstWhere(
        (e) => e.toString() == map['marriageIntent'],
      ),
      educationLevel: EducationLevel.values.firstWhere(
        (e) => e.toString() == map['educationLevel'],
      ),
      employmentStatus: EmploymentStatus.values.firstWhere(
        (e) => e.toString() == map['employmentStatus'],
      ),
      housingType: HousingType.values.firstWhere(
        (e) => e.toString() == map['housingType'],
      ),
      drinksAlcohol: map['drinksAlcohol'] as bool,
      smokes: map['smokes'] as bool,
      prayerStatus: PrayerStatus.values.firstWhere(
        (e) => e.toString() == map['prayerStatus'],
      ),
      wearGlasses: GlassesStatus.values.firstWhere(
        (e) => e.toString() == map['wearGlasses'],
      ),
      heightCm: map['heightCm'] as int,
      skinColor: SkinColor.values.firstWhere(
        (e) => e.toString() == map['skinColor'],
      ),
      bodyType: BodyType.values.firstWhere(
        (e) => e.toString() == map['bodyType'],
      ),
      profileImageUrl: map['profileImageUrl'] as String?,
      profileImageHidden: map['profileImageHidden'] as bool? ?? true,
      profileComplete: map['profileComplete'] as bool? ?? false,
      accountStatus: AccountStatus.values.firstWhere(
        (e) => e.toString() == map['accountStatus'],
      ),
      partnerId: map['partnerId'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
      viewedBy: List<String>.from(map['viewedBy'] as List? ?? []),
    );
  }
}
