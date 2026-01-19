import 'package:flutter/material.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: isArabic ? ArabicStrings.settingsScreen : EnglishStrings.settingsScreen,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSectionHeader(isArabic ? 'الملف الشخصي' : 'Profile'),
          _buildSettingsTile(
            icon: Icons.person,
            title: isArabic ? ArabicStrings.editProfile : EnglishStrings.editProfile,
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildSettingsTile(
            icon: Icons.image,
            title: isArabic ? ArabicStrings.photo : EnglishStrings.photo,
            onTap: () => Navigator.pushNamed(context, '/photo'),
          ),
          const Divider(),

          // Preferences Section
          _buildSectionHeader(isArabic ? 'التفضيلات' : 'Preferences'),
          _buildSettingsTile(
            icon: Icons.language,
            title: isArabic ? ArabicStrings.language : EnglishStrings.language,
            onTap: () => _showLanguageDialog(context, isArabic),
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: isArabic ? ArabicStrings.partnerCriteria : EnglishStrings.partnerCriteria,
            onTap: () => Navigator.pushNamed(context, '/partner-criteria'),
          ),
          const Divider(),

          // Legal Section
          _buildSectionHeader(isArabic ? 'قانوني' : 'Legal'),
          _buildSettingsTile(
            icon: Icons.description,
            title: isArabic ? ArabicStrings.termsAndConditions : EnglishStrings.termsAndConditions,
            onTap: () => _showTermsDialog(context, isArabic),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: isArabic ? ArabicStrings.privacy : EnglishStrings.privacy,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isArabic ? 'سياسة الخصوصية' : 'Privacy Policy'),
              ),
            ),
          ),
          const Divider(),

          // Account Section
          _buildSectionHeader(isArabic ? 'الحساب' : 'Account'),
          _buildSettingsTile(
            icon: Icons.info,
            title: isArabic ? ArabicStrings.about : EnglishStrings.about,
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          _buildSettingsTile(
            icon: Icons.email,
            title: isArabic ? ArabicStrings.contactUs : EnglishStrings.contactUs,
            onTap: () => Navigator.pushNamed(context, '/contact'),
          ),
          _buildSettingsTile(
            icon: Icons.bar_chart,
            title: isArabic ? ArabicStrings.statistics : EnglishStrings.statistics,
            onTap: () => Navigator.pushNamed(context, '/statistics'),
          ),
          _buildSettingsTile(
            icon: Icons.delete_outline,
            title: isArabic ? ArabicStrings.deleteAccount : EnglishStrings.deleteAccount,
            iconColor: Colors.red,
            onTap: () => _showDeleteAccountDialog(context, isArabic),
          ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: isArabic ? ArabicStrings.logout : EnglishStrings.logout,
            iconColor: Colors.red,
            onTap: () => _showLogoutDialog(context, isArabic),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.blue,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'اختر اللغة' : 'Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioMenuButton<String>(
              value: 'ar',
              groupValue: language,
              onChanged: (value) {
                setState(() => language = value ?? 'ar');
                Navigator.pop(context);
              },
              child: const Text('العربية 🇸🇦'),
            ),
            RadioMenuButton<String>(
              value: 'en',
              groupValue: language,
              onChanged: (value) {
                setState(() => language = value ?? 'en');
                Navigator.pop(context);
              },
              child: const Text('English 🇬🇧'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'الشروط والأحكام' : 'Terms and Conditions'),
        content: SingleChildScrollView(
          child: Text(
            isArabic
                ? 'باستخدامك لهذا التطبيق، فإنك تقرّ وتوافق على ما يلي:\n\n• الغرض من التطبيق هو الزواج الشرعي فقط.\n• يمنع استخدام التطبيق لأي علاقة خارج إطار الزواج.\n• جميع المعلومات المقدمة صحيحة وعلى مسؤولية المستخدم.'
                : 'By using this application, you agree to the following:\n\n• The purpose of the application is lawful marriage only.\n• The application is prohibited from being used for any relationship outside the framework of marriage.\n• All information provided is accurate and the user is responsible for it.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'موافق' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'حذف الحساب' : 'Delete Account'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.'
              : 'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/splash');
            },
            child: Text(
              isArabic ? 'حذف' : 'Delete',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
        content: Text(
          isArabic ? 'هل تريد تسجيل الخروج؟' : 'Do you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/splash');
            },
            child: Text(
              isArabic ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
