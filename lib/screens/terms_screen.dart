import 'package:flutter/material.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  late String language;
  bool agreeToTerms = false;

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
        title: isArabic ? ArabicStrings.termsAndConditions : EnglishStrings.termsAndConditions,
        onBackPressed: () => Navigator.pop(context),
        showForwardButton: true,
        onForwardPressed: agreeToTerms
            ? () => Navigator.pushNamed(context, '/photo')
            : null,
      ),
      body: Column(
        children: [
          // Terms Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  isArabic
                      ? 'شروط الاستخدام والأحكام'
                      : 'Terms of Use and Conditions',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isArabic ? termsAndConditionsAr : termsAndConditionsEn,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),

          // Agreement Checkbox and Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: agreeToTerms,
                  onChanged: (value) {
                    setState(() => agreeToTerms = value ?? false);
                  },
                  title: Text(
                    isArabic
                        ? 'أوافق على جميع الشروط والأحكام'
                        : 'I agree to all terms and conditions',
                    style: const TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  label: isArabic ? ArabicStrings.next : EnglishStrings.next,
                  onPressed: agreeToTerms
                      ? () => Navigator.pushNamed(context, '/photo')
                      : () {},
                  backgroundColor: agreeToTerms ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String termsAndConditionsAr = '''
باستخدامك لهذا التطبيق، فإنك تقرّ وتوافق على ما يلي:

• الغرض من التطبيق هو الزواج الشرعي فقط.
• يمنع استخدام التطبيق لأي علاقة خارج إطار الزواج.
• يمنع إرسال أرقام الهواتف أو روابط التواصل قبل فتح التواصل الرسمي.
• جميع المعلومات المقدمة صحيحة وعلى مسؤولية المستخدم.
• يحق لإدارة التطبيق تعليق أو حذف أي حساب مخالف دون إشعار مسبق.

شروط أخلاقية وتعهد:
• أتعهد بالجدية والالتزام
• أتعهد بعدم إساءة استخدام التطبيق
• أتعهد أن جميع البيانات المقدمة صحيحة وحقيقية
• أتعهد بإخبار الطرف الآخر بأي حالة مرضية معدية أو مزمنة قد تؤثر على الحياة الزوجية قبل إتمام أي خطوة رسمية

نحن نحتفظ بالحق في:
• حذف أي محتوى يخالف القيم الإسلامية والأخلاقيات
• تعليق أو حذف أي حساب بدون إشعار مسبق
• تعديل شروط الاستخدام في أي وقت
''';

const String termsAndConditionsEn = '''
By using this application, you agree to the following:

• The purpose of the application is lawful marriage only.
• The application is prohibited from being used for any relationship outside the framework of marriage.
• It is forbidden to send phone numbers or contact links before opening official communication.
• All information provided is accurate and the user is responsible for it.
• The application administration has the right to suspend or delete any non-compliant account without prior notice.

Ethical Conditions and Commitment:
• I commit to seriousness and dedication
• I commit to not misusing the application
• I commit that all data provided is accurate and genuine
• I undertake to inform the other party of any contagious or chronic condition that may affect married life before taking any formal step

We reserve the right to:
• Delete any content that violates Islamic values and ethics
• Suspend or delete any account without prior notice
• Modify the terms of use at any time
''';
