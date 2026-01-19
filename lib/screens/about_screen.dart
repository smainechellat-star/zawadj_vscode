import 'package:flutter/material.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late String language;

  @override
  void initState() {
    super.initState();
    language = 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
      

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? ArabicStrings.about : EnglishStrings.about,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.favorite, size: 80, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            Text(
              'ZAWADJ',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Version
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${isArabic ? ArabicStrings.version : EnglishStrings.version} 2026',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),

            // About Text
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  isArabic ? aboutAppAr : aboutAppEn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Developer Info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      isArabic ? 'مطور التطبيق' : 'App Developer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Smaine Chellat',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Features
            Text(
              isArabic ? 'المميزات' : 'Features',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildFeature(
              '✅ ${isArabic ? 'تطبيق آمن وموثوق' : 'Safe and Trustworthy'}',
            ),
            _buildFeature('✅ ${isArabic ? 'تطابق ذكي' : 'Smart Matching'}'),
            _buildFeature('✅ ${isArabic ? 'دردشة آمنة' : 'Secure Chat'}'),
            _buildFeature(
              '✅ ${isArabic ? 'تحكم كامل بالخصوصية' : 'Complete Privacy Control'}',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
    );
  }
}

const String aboutAppAr = '''
تم تطوير هذا التطبيق بهدف تسهيل التعارف الجاد والزواج الشرعي.

مالك ومشرف التطبيق:
الاسم: سماعين شلاط

تم تصميم هذا التطبيق خصيصًا لأجهزة الأندرويد.
الإصدار: 2026

لا تنسونا من صالح دعائكم
''';

const String aboutAppEn = '''
This application has been developed to facilitate serious networking and lawful marriage.

Application Owner and Administrator:
Name: Smaine Chellat

This application was designed specifically for Android devices.
Version: 2026

Do not forget us in your kind prayers
''';
