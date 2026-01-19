import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import '../models/enums.dart';
import '../utils/constants.dart';

class PartnerCriteriaScreen extends StatefulWidget {
  const PartnerCriteriaScreen({super.key});

  @override
  State<PartnerCriteriaScreen> createState() => _PartnerCriteriaScreenState();
}

class _PartnerCriteriaScreenState extends State<PartnerCriteriaScreen> {
  late String language;

  // المعايير المختارة
  List<int> selectedAgeRange = [18, 35];
  List<String> selectedCountries = [];
  List<String> selectedStates = [];
  List<MaritalStatus> selectedMaritalStatuses = [];
  List<EducationLevel> selectedEducationLevels = [];
  List<SkinColor> selectedSkinColors = [];
  List<BodyType> selectedBodyTypes = [];
  ChildrenPreference? selectedChildrenPreference;
  HabitStatus? selectedAlcoholDrugs;
  HabitStatus? selectedSmoking;
  PrayerStatus? selectedPrayerStatus;
  GlassesPreference? selectedGlassesPreference;
  List<int> selectedHeightRange = [150, 180];
  AppearanceFilter? selectedAppearance;
  Gender? userGender;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    language = 'ar';
    _loadPartnerCriteria();
    // يمكن الحصول على جنس المستخدم من الـ Provider أو من الملف الشخصي المحفوظ
  }

  Future<void> _loadPartnerCriteria() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Load user gender
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData?['gender'] != null) {
          try {
            userGender = Gender.values.firstWhere(
              (e) => e.name == userData!['gender'],
              orElse: () => Gender.male,
            );
          } catch (e) {
            userGender = null;
          }
        }
      }

      // Load partner criteria
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('preferences')
          .doc('partner_criteria')
          .get();

      if (doc.exists && mounted) {
        final data = doc.data();
        if (data != null) {
          setState(() {
            selectedAgeRange = List<int>.from(data['ageRange'] ?? [18, 35]);
            selectedCountries = List<String>.from(data['countries'] ?? []);
            selectedStates = List<String>.from(data['states'] ?? []);
            
            // Safely parse marital statuses
            selectedMaritalStatuses = (data['maritalStatuses'] as List<dynamic>?)
                ?.map((e) {
                  try {
                    return MaritalStatus.values.firstWhere((ms) => ms.name == e);
                  } catch (_) {
                    return null;
                  }
                })
                .where((e) => e != null)
                .cast<MaritalStatus>()
                .toList() ?? [];
            
            // Safely parse education levels
            selectedEducationLevels = (data['educationLevels'] as List<dynamic>?)
                ?.map((e) {
                  try {
                    return EducationLevel.values.firstWhere((el) => el.name == e);
                  } catch (_) {
                    return null;
                  }
                })
                .where((e) => e != null)
                .cast<EducationLevel>()
                .toList() ?? [];
            
            // Safely parse skin colors
            selectedSkinColors = (data['skinColors'] as List<dynamic>?)
                ?.map((e) {
                  try {
                    return SkinColor.values.firstWhere((sc) => sc.name == e);
                  } catch (_) {
                    return null;
                  }
                })
                .where((e) => e != null)
                .cast<SkinColor>()
                .toList() ?? [];
            
            // Safely parse body types
            selectedBodyTypes = (data['bodyTypes'] as List<dynamic>?)
                ?.map((e) {
                  try {
                    return BodyType.values.firstWhere((bt) => bt.name == e);
                  } catch (_) {
                    return null;
                  }
                })
                .where((e) => e != null)
                .cast<BodyType>()
                .toList() ?? [];
            
            selectedHeightRange = List<int>.from(data['heightRange'] ?? [150, 180]);
            
            // Safely parse single enum values
            if (data['childrenPreference'] != null) {
              try {
                selectedChildrenPreference = ChildrenPreference.values
                    .firstWhere((e) => e.name == data['childrenPreference']);
              } catch (_) {
                selectedChildrenPreference = null;
              }
            }
            
            if (data['alcoholDrugs'] != null) {
              try {
                selectedAlcoholDrugs = HabitStatus.values
                    .firstWhere((e) => e.name == data['alcoholDrugs']);
              } catch (_) {
                selectedAlcoholDrugs = null;
              }
            }
            
            if (data['smoking'] != null) {
              try {
                selectedSmoking = HabitStatus.values
                    .firstWhere((e) => e.name == data['smoking']);
              } catch (_) {
                selectedSmoking = null;
              }
            }
            
            if (data['prayerStatus'] != null) {
              try {
                selectedPrayerStatus = PrayerStatus.values
                    .firstWhere((e) => e.name == data['prayerStatus']);
              } catch (_) {
                selectedPrayerStatus = null;
              }
            }
            
            if (data['glassesPreference'] != null) {
              try {
                selectedGlassesPreference = GlassesPreference.values
                    .firstWhere((e) => e.name == data['glassesPreference']);
              } catch (_) {
                selectedGlassesPreference = null;
              }
            }
            
            if (data['appearance'] != null) {
              try {
                selectedAppearance = AppearanceFilter.values
                    .firstWhere((e) => e.name == data['appearance']);
              } catch (_) {
                selectedAppearance = null;
              }
            }
          });
        }
      }
    } catch (e) {
      // Silently fail - criteria might not exist yet
    }
  }

  Future<void> _savePartnerCriteria() async {
    setState(() => _isSaving = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final criteriaData = {
        'ageRange': selectedAgeRange,
        'countries': selectedCountries,
        'states': selectedStates,
        'maritalStatuses': selectedMaritalStatuses.map((e) => e.name).toList(),
        'educationLevels': selectedEducationLevels.map((e) => e.name).toList(),
        'skinColors': selectedSkinColors.map((e) => e.name).toList(),
        'bodyTypes': selectedBodyTypes.map((e) => e.name).toList(),
        'heightRange': selectedHeightRange,
        'childrenPreference': selectedChildrenPreference?.name,
        'alcoholDrugs': selectedAlcoholDrugs?.name,
        'smoking': selectedSmoking?.name,
        'prayerStatus': selectedPrayerStatus?.name,
        'glassesPreference': selectedGlassesPreference?.name,
        'appearance': selectedAppearance?.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('preferences')
          .doc('partner_criteria')
          .set(criteriaData, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ معايير الشريك بنجاح / Partner criteria saved successfully'),
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

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? ArabicStrings.partnerCriteria : EnglishStrings.partnerCriteria,
        onBackPressed: () => Navigator.pop(context),
        showForwardButton: true,
        onForwardPressed: _isSaving ? null : () async {
          await _savePartnerCriteria();
          if (!context.mounted) return;
          Navigator.pushNamed(context, '/terms');
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(isArabic ? 'معايير البحث الأساسية' : 'Basic Search Criteria'),
          const SizedBox(height: 15),

          // Age Range
          Text(
            isArabic ? ArabicStrings.preferredAge : EnglishStrings.preferredAge,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: CustomDropdown<int>(
                    label: isArabic ? 'من' : 'From',
                    value: selectedAgeRange[0],
                    items: AppConstants.ageRange,
                    itemLabel: (age) => age.toString(),
                    onChanged: (value) {
                      if (value != null && value <= selectedAgeRange[1]) {
                        setState(() => selectedAgeRange[0] = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomDropdown<int>(
                    label: isArabic ? 'إلى' : 'To',
                    value: selectedAgeRange[1],
                    items: AppConstants.ageRange,
                    itemLabel: (age) => age.toString(),
                    onChanged: (value) {
                      if (value != null && value >= selectedAgeRange[0]) {
                        setState(() => selectedAgeRange[1] = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // الدولة - Multi-select Checkbox
          _buildMultiSelectDropdown(
            label: isArabic ? 'الدولة' : 'Country',
            items: AppConstants.countries,
            selectedItems: selectedCountries,
            itemLabel: (country) => country,
            onChanged: (selected) {
              setState(() => selectedCountries = selected);
            },
          ),
          const SizedBox(height: 20),

          // الولاية - Multi-select Checkbox (ولايات الجزائر)
          _buildMultiSelectDropdown(
            label: isArabic ? 'الولاية (الجزائر)' : 'State (Algeria)',
            items: AppConstants.algerianCities,
            selectedItems: selectedStates,
            itemLabel: (state) => state,
            onChanged: (selected) {
              setState(() => selectedStates = selected);
            },
          ),
          const SizedBox(height: 20),

          // Marital Status Multi-select (مع إخفاء المتزوج للذكر)
          _buildMultiSelectDropdown(
            label: isArabic ? ArabicStrings.preferredMaritalStatus : EnglishStrings.preferredMaritalStatus,
            items: _getMaritalStatusOptions(),
            selectedItems: selectedMaritalStatuses,
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
            onChanged: (selected) {
              setState(() => selectedMaritalStatuses = selected);
            },
          ),
          const SizedBox(height: 20),

          // المستوى التعليمي - Multi-select Checkbox
          _buildMultiSelectDropdown(
            label: isArabic ? ArabicStrings.preferredEducation : EnglishStrings.preferredEducation,
            items: EducationLevel.values,
            selectedItems: selectedEducationLevels,
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
            onChanged: (selected) {
              setState(() => selectedEducationLevels = selected);
            },
          ),
          const SizedBox(height: 30),

          // قسم المعايير الإضافية
          _buildSectionHeader(isArabic ? 'المعايير الإضافية' : 'Additional Criteria'),
          const SizedBox(height: 15),

          // الرغبة في الإنجاب
          CustomDropdown<ChildrenPreference>(
            label: isArabic ? 'الرغبة في الإنجاب' : 'Desire for Children',
            value: selectedChildrenPreference,
            items: ChildrenPreference.values,
            itemLabel: (pref) {
              switch (pref) {
                case ChildrenPreference.yes:
                  return isArabic ? 'نعم' : 'Yes';
                case ChildrenPreference.no:
                  return isArabic ? 'لا' : 'No';
                case ChildrenPreference.doesntMatter:
                  return isArabic ? 'لا يهم' : "Doesn't Matter";
              }
            },
            onChanged: (value) {
              setState(() => selectedChildrenPreference = value);
            },
          ),
          const SizedBox(height: 15),

          // الخمر والمخدرات
          CustomDropdown<HabitStatus>(
            label: isArabic ? 'الخمر والمخدرات' : 'Alcohol & Drugs',
            value: selectedAlcoholDrugs,
            items: HabitStatus.values,
            itemLabel: (status) {
              switch (status) {
                case HabitStatus.yes:
                  return isArabic ? 'نعم' : 'Yes';
                case HabitStatus.no:
                  return isArabic ? 'لا' : 'No';
                case HabitStatus.noMatter:
                  return isArabic ? 'لا يهم' : "Doesn't Matter";
              }
            },
            onChanged: (value) {
              setState(() => selectedAlcoholDrugs = value);
            },
          ),
          const SizedBox(height: 15),

          // التدخين
          CustomDropdown<HabitStatus>(
            label: isArabic ? ArabicStrings.smoking : EnglishStrings.smoking,
            value: selectedSmoking,
            items: HabitStatus.values,
            itemLabel: (status) {
              switch (status) {
                case HabitStatus.yes:
                  return isArabic ? 'نعم' : 'Yes';
                case HabitStatus.no:
                  return isArabic ? 'لا' : 'No';
                case HabitStatus.noMatter:
                  return isArabic ? 'لا يهم' : "Doesn't Matter";
              }
            },
            onChanged: (value) {
              setState(() => selectedSmoking = value);
            },
          ),
          const SizedBox(height: 15),

          // الصلاة
          CustomDropdown<PrayerStatus>(
            label: isArabic ? ArabicStrings.prayer : EnglishStrings.prayer,
            value: selectedPrayerStatus,
            items: PrayerStatus.values,
            itemLabel: (status) {
              switch (status) {
                case PrayerStatus.regular:
                  return isArabic ? ArabicStrings.regular : EnglishStrings.regular;
                case PrayerStatus.irregular:
                  return isArabic ? ArabicStrings.irregular : EnglishStrings.irregular;
                case PrayerStatus.doesntMatter:
                  return isArabic ? ArabicStrings.doesntMatter : EnglishStrings.doesntMatter;
              }
            },
            onChanged: (value) {
              setState(() => selectedPrayerStatus = value);
            },
          ),
          const SizedBox(height: 30),

          // قسم المظهر الخارجي
          _buildSectionHeader(isArabic ? 'المظهر الخارجي' : 'Physical Appearance'),
          const SizedBox(height: 15),

          // أهمية المظهر الخارجي
          CustomDropdown<AppearanceFilter>(
            label: isArabic ? 'أهمية المظهر الخارجي' : 'Appearance Importance',
            value: selectedAppearance,
            items: AppearanceFilter.values,
            itemLabel: (filter) {
              switch (filter) {
                case AppearanceFilter.veryImportant:
                  return isArabic ? 'مهم جداً' : 'Very Important';
                case AppearanceFilter.important:
                  return isArabic ? 'مهم' : 'Important';
                case AppearanceFilter.doesntMatter:
                  return isArabic ? 'لا يهم' : "Doesn't Matter";
              }
            },
            onChanged: (value) {
              setState(() => selectedAppearance = value);
            },
          ),
          const SizedBox(height: 15),

          // لبس النظارات
          CustomDropdown<GlassesPreference>(
            label: isArabic ? 'لبس النظارات' : 'Wears Glasses',
            value: selectedGlassesPreference,
            items: GlassesPreference.values,
            itemLabel: (pref) {
              switch (pref) {
                case GlassesPreference.yes:
                  return isArabic ? 'نعم' : 'Yes';
                case GlassesPreference.no:
                  return isArabic ? 'لا' : 'No';
                case GlassesPreference.doesntMatter:
                  return isArabic ? 'لا يهم' : "Doesn't Matter";
              }
            },
            onChanged: (value) {
              setState(() => selectedGlassesPreference = value);
            },
          ),
          const SizedBox(height: 15),

          // الطول بالسنتمترات
          Text(
            isArabic ? 'الطول بالسنتمترات (100-200)' : 'Height in cm (100-200)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: CustomDropdown<int>(
                    label: isArabic ? 'من' : 'From',
                    value: selectedHeightRange[0],
                    items: AppConstants.heightRange,
                    itemLabel: (height) => height.toString(),
                    onChanged: (value) {
                      if (value != null && value <= selectedHeightRange[1]) {
                        setState(() => selectedHeightRange[0] = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomDropdown<int>(
                    label: isArabic ? 'إلى' : 'To',
                    value: selectedHeightRange[1],
                    items: AppConstants.heightRange,
                    itemLabel: (height) => height.toString(),
                    onChanged: (value) {
                      if (value != null && value >= selectedHeightRange[0]) {
                        setState(() => selectedHeightRange[1] = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // لون البشرة - Multi-select Checkbox
          _buildMultiSelectDropdown(
            label: isArabic ? 'لون البشرة' : 'Skin Color',
            items: SkinColor.values.where((c) => c != SkinColor.noPreference).toList(),
            selectedItems: selectedSkinColors,
            itemLabel: (color) {
              switch (color) {
                case SkinColor.fair:
                  return isArabic ? 'فاتح' : 'Fair';
                case SkinColor.wheatish:
                  return isArabic ? 'قمحي' : 'Wheatish';
                case SkinColor.brown:
                  return isArabic ? 'بني' : 'Brown';
                case SkinColor.dark:
                  return isArabic ? 'داكن' : 'Dark';
                case SkinColor.noPreference:
                  return '';
              }
            },
            onChanged: (selected) {
              setState(() => selectedSkinColors = selected);
            },
          ),
          const SizedBox(height: 20),

          // البنية الجسدية - Multi-select Checkbox
          _buildMultiSelectDropdown(
            label: isArabic ? 'البنية الجسدية' : 'Body Type',
            items: BodyType.values.where((b) => b != BodyType.noPreference).toList(),
            selectedItems: selectedBodyTypes,
            itemLabel: (type) {
              switch (type) {
                case BodyType.slim:
                  return isArabic ? 'نحيف' : 'Slim';
                case BodyType.average:
                  return isArabic ? 'متوسط' : 'Average';
                case BodyType.heavyset:
                  return isArabic ? 'ممتلئ' : 'Heavyset';
                case BodyType.athletic:
                  return isArabic ? 'رياضي' : 'Athletic';
                case BodyType.noPreference:
                  return '';
              }
            },
            onChanged: (selected) {
              setState(() => selectedBodyTypes = selected);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // تحديد خيارات الحالة الاجتماعية حسب جنس المستخدم
  List<MaritalStatus> _getMaritalStatusOptions() {
    if (userGender == Gender.male) {
      // إخفاء "متزوج" للذكور
      return MaritalStatus.values.where((status) => status != MaritalStatus.married).toList();
    }
    return MaritalStatus.values;
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildMultiSelectDropdown<T>({
    required String label,
    required List<T> items,
    required List<T> selectedItems,
    required String Function(T) itemLabel,
    required Function(List<T>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView(
            shrinkWrap: true,
            children: items.map((item) {
              final isSelected = selectedItems.contains(item);
              return CheckboxListTile(
                title: Text(itemLabel(item)),
                value: isSelected,
                onChanged: (value) {
                  List<T> newSelected = List.from(selectedItems);
                  if (value == true) {
                    newSelected.add(item);
                  } else {
                    newSelected.remove(item);
                  }
                  onChanged(newSelected);
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
