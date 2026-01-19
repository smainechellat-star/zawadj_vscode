import 'enums.dart';

class PartnerCriteria {
  final String userId;
  final List<int> ageRange; // [minAge, maxAge]
  final List<String> preferredCountries;
  final List<String> preferredStates;
  final List<HousingType> housingTypes;
  final List<MaritalStatus> maritalStatuses;
  final List<EmploymentStatus> employmentStatuses;
  final List<EducationLevel> educationLevels;
  final bool? wantChildren;
  final bool? acceptDrinking;
  final bool? acceptSmoking;
  final PrayerStatus? prayerPreference;
  final GlassesStatus? glassesPreference;
  final List<int>? heightRange; // [minHeight, maxHeight]
  final List<SkinColor> skinColors;
  final List<BodyType> bodyTypes;
  final DateTime createdAt;
  final DateTime lastUpdated;

  PartnerCriteria({
    required this.userId,
    required this.ageRange,
    required this.preferredCountries,
    required this.preferredStates,
    required this.housingTypes,
    required this.maritalStatuses,
    required this.employmentStatuses,
    required this.educationLevels,
    this.wantChildren,
    this.acceptDrinking,
    this.acceptSmoking,
    this.prayerPreference,
    this.glassesPreference,
    this.heightRange,
    required this.skinColors,
    required this.bodyTypes,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'ageRange': ageRange,
      'preferredCountries': preferredCountries,
      'preferredStates': preferredStates,
      'housingTypes': housingTypes.map((e) => e.toString()).toList(),
      'maritalStatuses': maritalStatuses.map((e) => e.toString()).toList(),
      'employmentStatuses': employmentStatuses
          .map((e) => e.toString())
          .toList(),
      'educationLevels': educationLevels.map((e) => e.toString()).toList(),
      'wantChildren': wantChildren,
      'acceptDrinking': acceptDrinking,
      'acceptSmoking': acceptSmoking,
      'prayerPreference': prayerPreference?.toString(),
      'glassesPreference': glassesPreference?.toString(),
      'heightRange': heightRange,
      'skinColors': skinColors.map((e) => e.toString()).toList(),
      'bodyTypes': bodyTypes.map((e) => e.toString()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PartnerCriteria.fromMap(Map<String, dynamic> map) {
    return PartnerCriteria(
      userId: map['userId'],
      ageRange: List<int>.from(map['ageRange']),
      preferredCountries: List<String>.from(map['preferredCountries']),
      preferredStates: List<String>.from(map['preferredStates']),
      housingTypes: (map['housingTypes'] as List)
          .map((e) => HousingType.values.firstWhere((ht) => ht.toString() == e))
          .toList(),
      maritalStatuses: (map['maritalStatuses'] as List)
          .map(
            (e) => MaritalStatus.values.firstWhere((ms) => ms.toString() == e),
          )
          .toList(),
      employmentStatuses: (map['employmentStatuses'] as List)
          .map(
            (e) =>
                EmploymentStatus.values.firstWhere((es) => es.toString() == e),
          )
          .toList(),
      educationLevels: (map['educationLevels'] as List)
          .map(
            (e) => EducationLevel.values.firstWhere((el) => el.toString() == e),
          )
          .toList(),
      wantChildren: map['wantChildren'],
      acceptDrinking: map['acceptDrinking'],
      acceptSmoking: map['acceptSmoking'],
      prayerPreference: map['prayerPreference'] != null
          ? PrayerStatus.values.firstWhere(
              (e) => e.toString() == map['prayerPreference'],
            )
          : null,
      glassesPreference: map['glassesPreference'] != null
          ? GlassesStatus.values.firstWhere(
              (e) => e.toString() == map['glassesPreference'],
            )
          : null,
      heightRange: map['heightRange'] != null
          ? List<int>.from(map['heightRange'])
          : null,
      skinColors: (map['skinColors'] as List)
          .map((e) => SkinColor.values.firstWhere((sc) => sc.toString() == e))
          .toList(),
      bodyTypes: (map['bodyTypes'] as List)
          .map((e) => BodyType.values.firstWhere((bt) => bt.toString() == e))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}
