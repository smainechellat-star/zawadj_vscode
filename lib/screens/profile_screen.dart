import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import '../models/enums.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String language;

  final firstNameController = TextEditingController();
  Gender? selectedGender;
  int? selectedAge;
  String? selectedCountry;
  String? selectedState;
  MaritalStatus? selectedMaritalStatus;
  int? selectedHeight;
  SkinColor? selectedSkinColor;
  BodyType? selectedBodyType;
  EducationLevel? selectedEducationLevel;
  EmploymentStatus? selectedEmploymentStatus;
  HousingType? selectedHousingType;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    language = 'ar';
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && mounted) {
        final data = doc.data();
        if (data != null) {
          setState(() {
            firstNameController.text = data['firstName'] ?? '';
            selectedAge = data['age'];
            selectedGender = data['gender'] != null 
                ? Gender.values.firstWhere((e) => e.name == data['gender']) 
                : null;
            selectedCountry = data['country'];
            selectedState = data['state'];
            selectedMaritalStatus = data['maritalStatus'] != null
                ? MaritalStatus.values.firstWhere((e) => e.name == data['maritalStatus'])
                : null;
            selectedHeight = data['height'];
            selectedSkinColor = data['skinColor'] != null
                ? SkinColor.values.firstWhere((e) => e.name == data['skinColor'])
                : null;
            selectedBodyType = data['bodyType'] != null
                ? BodyType.values.firstWhere((e) => e.name == data['bodyType'])
                : null;
            selectedEducationLevel = data['educationLevel'] != null
                ? EducationLevel.values.firstWhere((e) => e.name == data['educationLevel'])
                : null;
            selectedEmploymentStatus = data['employmentStatus'] != null
                ? EmploymentStatus.values.firstWhere((e) => e.name == data['employmentStatus'])
                : null;
            selectedHousingType = data['housingType'] != null
                ? HousingType.values.firstWhere((e) => e.name == data['housingType'])
                : null;
          });
        }
      }
    } catch (e) {
      // Silently fail - profile might not exist yet
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
      

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? ArabicStrings.profile : EnglishStrings.profile,
        onBackPressed: () => Navigator.pop(context),
        showForwardButton: true,
        onForwardPressed: _isSaving ? null : () async {
          if (!_validateForm()) return;
          await _saveProfileData();
          if (!context.mounted) return;
          Navigator.pushNamed(context, '/partner-criteria');
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Basic Information Section
          _buildSectionHeader(
            isArabic ? 'المعلومات الأساسية' : 'Basic Information',
          ),
          const SizedBox(height: 15),

          CustomTextField(
            label: isArabic ? ArabicStrings.firstName : EnglishStrings.firstName,
            controller: firstNameController,
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 15),

          // Age Dropdown
          CustomDropdown<int>(
            label: isArabic ? ArabicStrings.age : EnglishStrings.age,
            value: selectedAge,
            items: AppConstants.ageRange,
            itemLabel: (age) => age.toString(),
            onChanged: (value) => setState(() => selectedAge = value),
          ),
          const SizedBox(height: 15),

          // Gender Dropdown
          CustomDropdown<Gender>(
            label: isArabic ? ArabicStrings.gender : EnglishStrings.gender,
            value: selectedGender,
            items: Gender.values,
            itemLabel: (gender) =>
                gender == Gender.male ? isArabic ? ArabicStrings.male : EnglishStrings.male : isArabic ? ArabicStrings.female : EnglishStrings.female,
            onChanged: (value) => setState(() => selectedGender = value),
          ),
          const SizedBox(height: 15),

          // Country Dropdown
          CustomDropdown<String>(
            label: isArabic ? ArabicStrings.country : EnglishStrings.country,
            value: selectedCountry,
            items: AppConstants.countries,
            itemLabel: (country) => country,
            onChanged: (value) => setState(() => selectedCountry = value),
          ),
          const SizedBox(height: 15),

          // State Dropdown
          CustomDropdown<String>(
            label: isArabic ? ArabicStrings.state : EnglishStrings.state,
            value: selectedState,
            items: AppConstants.algerianCities,
            itemLabel: (state) => state,
            onChanged: (value) => setState(() => selectedState = value),
          ),
          const SizedBox(height: 15),

          // Marital Status Dropdown
          CustomDropdown<MaritalStatus>(
            label: isArabic ? ArabicStrings.maritalStatus : EnglishStrings.maritalStatus,
            value: selectedMaritalStatus,
            items: MaritalStatus.values,
            itemLabel: (status) {
              switch (status) {
                case MaritalStatus.single:
                  return isArabic ? ArabicStrings.single : EnglishStrings.single;
                case MaritalStatus.married:
                  return isArabic ? ArabicStrings.married_ : EnglishStrings.married_;
                case MaritalStatus.divorced:
                  return isArabic ? ArabicStrings.divorced : EnglishStrings.divorced;
                case MaritalStatus.widowed:
                  return isArabic ? ArabicStrings.widowed : EnglishStrings.widowed;
              }
            },
            onChanged: (value) => setState(() => selectedMaritalStatus = value),
          ),
          const SizedBox(height: 30),

          // Social Information Section
          _buildSectionHeader(
            isArabic ? 'المعلومات الاجتماعية' : 'Social Information',
          ),
          const SizedBox(height: 15),

          // Education Level
          CustomDropdown<EducationLevel>(
            label: isArabic ? ArabicStrings.educationLevel : EnglishStrings.educationLevel,
            value: selectedEducationLevel,
            items: EducationLevel.values,
            itemLabel: (level) {
              switch (level) {
                case EducationLevel.primary:
                  return isArabic ? ArabicStrings.primary : EnglishStrings.primary;
                case EducationLevel.middle:
                  return isArabic ? ArabicStrings.middle : EnglishStrings.middle;
                case EducationLevel.secondary:
                  return isArabic ? ArabicStrings.secondary : EnglishStrings.secondary;
                case EducationLevel.university:
                  return isArabic ? ArabicStrings.university : EnglishStrings.university;
              }
            },
            onChanged: (value) => setState(() => selectedEducationLevel = value),
          ),
          const SizedBox(height: 15),

          // Employment Status
          CustomDropdown<EmploymentStatus>(
            label: isArabic ? ArabicStrings.employment : EnglishStrings.employment,
            value: selectedEmploymentStatus,
            items: EmploymentStatus.values,
            itemLabel: (status) {
              switch (status) {
                case EmploymentStatus.governmentEmployee:
                  return isArabic ? ArabicStrings.governmentEmployee : EnglishStrings.governmentEmployee;
                case EmploymentStatus.privateEmployee:
                  return isArabic ? ArabicStrings.privateEmployee : EnglishStrings.privateEmployee;
                case EmploymentStatus.selfEmployed:
                  return isArabic ? ArabicStrings.selfEmployed : EnglishStrings.selfEmployed;
                case EmploymentStatus.unemployed:
                  return isArabic ? ArabicStrings.unemployed : EnglishStrings.unemployed;
                case EmploymentStatus.retired:
                  return isArabic ? ArabicStrings.retired : EnglishStrings.retired;
                case EmploymentStatus.noJob:
                  return isArabic ? ArabicStrings.noJob : EnglishStrings.noJob;
              }
            },
            onChanged: (value) => setState(() => selectedEmploymentStatus = value),
          ),
          const SizedBox(height: 15),

          // Housing Type
          CustomDropdown<HousingType>(
            label: isArabic ? ArabicStrings.housing : EnglishStrings.housing,
            value: selectedHousingType,
            items: HousingType.values,
            itemLabel: (type) {
              switch (type) {
                case HousingType.separateHouse:
                  return isArabic ? ArabicStrings.separateHouse : EnglishStrings.separateHouse;
                case HousingType.withParentsOnly:
                  return isArabic ? ArabicStrings.withParents : EnglishStrings.withParents;
                case HousingType.familySharedHouse:
                  return isArabic ? ArabicStrings.familyShared : EnglishStrings.familyShared;
              }
            },
            onChanged: (value) => setState(() => selectedHousingType = value),
          ),
          const SizedBox(height: 30),

          // Physical Appearance Section
          _buildSectionHeader(
            isArabic ? 'المظهر الخارجي' : 'Physical Appearance',
          ),
          const SizedBox(height: 15),

          // Height
          CustomDropdown<int>(
            label: isArabic ? ArabicStrings.height : EnglishStrings.height,
            value: selectedHeight,
            items: AppConstants.heightRange,
            itemLabel: (height) => '$height cm',
            onChanged: (value) => setState(() => selectedHeight = value),
          ),
          const SizedBox(height: 15),

          // Skin Color
          CustomDropdown<SkinColor>(
            label: isArabic ? ArabicStrings.skinColor : EnglishStrings.skinColor,
            value: selectedSkinColor,
            items: SkinColor.values,
            itemLabel: (color) {
              switch (color) {
                case SkinColor.fair:
                  return isArabic ? ArabicStrings.fair : EnglishStrings.fair;
                case SkinColor.wheatish:
                  return isArabic ? ArabicStrings.wheatish : EnglishStrings.wheatish;
                case SkinColor.brown:
                  return isArabic ? ArabicStrings.brown : EnglishStrings.brown;
                case SkinColor.dark:
                  return isArabic ? ArabicStrings.dark : EnglishStrings.dark;
                case SkinColor.noPreference:
                  return isArabic ? ArabicStrings.noPreference : EnglishStrings.noPreference;
              }
            },
            onChanged: (value) => setState(() => selectedSkinColor = value),
          ),
          const SizedBox(height: 15),

          // Body Type
          CustomDropdown<BodyType>(
            label: isArabic ? ArabicStrings.bodyType : EnglishStrings.bodyType,
            value: selectedBodyType,
            items: BodyType.values,
            itemLabel: (type) {
              switch (type) {
                case BodyType.slim:
                  return isArabic ? ArabicStrings.slim : EnglishStrings.slim;
                case BodyType.average:
                  return isArabic ? ArabicStrings.average : EnglishStrings.average;
                case BodyType.heavyset:
                  return isArabic ? ArabicStrings.heavyset : EnglishStrings.heavyset;
                case BodyType.athletic:
                  return isArabic ? ArabicStrings.athletic : EnglishStrings.athletic;
                case BodyType.noPreference:
                  return isArabic ? ArabicStrings.noPreference : EnglishStrings.noPreference;
              }
            },
            onChanged: (value) => setState(() => selectedBodyType = value),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty ||
        selectedAge == null ||
        selectedGender == null ||
        selectedCountry == null ||
        selectedState == null ||
        selectedMaritalStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveProfileData() async {
    setState(() => _isSaving = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profileData = {
        'firstName': firstNameController.text.trim(),
        'gender': selectedGender?.name,
        'age': selectedAge,
        'country': selectedCountry,
        'state': selectedState,
        'maritalStatus': selectedMaritalStatus?.name,
        'height': selectedHeight,
        'skinColor': selectedSkinColor?.name,
        'bodyType': selectedBodyType?.name,
        'educationLevel': selectedEducationLevel?.name,
        'employmentStatus': selectedEmploymentStatus?.name,
        'housingType': selectedHousingType?.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(profileData, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ البيانات بنجاح / Profile saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الحفظ / Save error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
