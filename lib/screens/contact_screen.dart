import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import '../utils/constants.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late String language;
  final messageController = TextEditingController();
  final subjectController = TextEditingController();
  bool _isSending = false;

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
        title: isArabic ? ArabicStrings.contactUs : EnglishStrings.contactUs,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.mail_outline, size: 60, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 30),

            // Contact Email
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isArabic ? ArabicStrings.contactEmail_ : EnglishStrings.contactEmail_,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      contactEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _launchEmail,
                        icon: const Icon(Icons.email),
                        label: Text(isArabic ? 'إرسال بريد' : 'Send Email'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Message Form
            Text(
              isArabic ? 'أرسل لنا رسالة' : 'Send Us a Message',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: isArabic ? 'الموضوع' : 'Subject',
              controller: subjectController,
              prefixIcon: Icons.subject,
            ),
            const SizedBox(height: 15),

            CustomTextField(
              label: isArabic ? 'الرسالة' : 'Message',
              controller: messageController,
              maxLines: 5,
              minLines: 3,
              prefixIcon: Icons.message,
            ),
            const SizedBox(height: 20),

            CustomButton(
              label: _isSending 
                  ? (isArabic ? 'جاري الإرسال...' : 'Sending...')
                  : (isArabic ? ArabicStrings.send : EnglishStrings.send),
              onPressed: _isSending ? null : () { _sendMessage(); },
              backgroundColor: _isSending ? Colors.grey : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      query: 'subject=ZAWADJ App - Contact',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                language == 'ar'
                    ? 'لا يمكن فتح تطبيق البريد'
                    : 'Cannot open email app',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ / Error: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    if (messageController.text.isEmpty || subjectController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            language == 'ar'
                ? 'يرجى ملء جميع الحقول'
                : 'Please fill all fields',
          ),
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      // حفظ الرسالة في Firestore
      await FirebaseFirestore.instance.collection('contact_messages').add({
        'userId': user?.uid ?? 'anonymous',
        'userEmail': user?.email ?? user?.phoneNumber ?? 'N/A',
        'subject': subjectController.text.trim(),
        'message': messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              language == 'ar'
                  ? 'تم إرسال الرسالة بنجاح'
                  : 'Message sent successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        messageController.clear();
        subjectController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${language == 'ar' ? 'خطأ في الإرسال' : 'Send error'}: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }
}
