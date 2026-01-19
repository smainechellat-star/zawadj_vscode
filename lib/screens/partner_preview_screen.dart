import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class PartnerPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> partnerData;

  const PartnerPreviewScreen({
    super.key,
    required this.partnerData,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? 'معاينة الملف الشخصي' : 'Profile Preview',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade100, Colors.white],
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      partnerData['image'] ?? '👤',
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name & Age
                  Text(
                    '${partnerData['name']}, ${partnerData['age']}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // City
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        partnerData['city'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Compatibility Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${isArabic ? 'التوافق: ' : 'Compatibility: '}${partnerData['score']}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Identifier Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal ID Section
                  _buildSectionTitle(
                    isArabic ? 'المعرف الشخصي' : 'Personal Identifier',
                    Icons.badge,
                  ),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    isArabic ? 'رقم الهوية' : 'ID Number',
                    partnerData['personalId'] ?? 'ZAWADJ-${DateTime.now().millisecondsSinceEpoch}',
                    Icons.fingerprint,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    isArabic ? 'الهوية الاجتماعية' : 'Social ID',
                    partnerData['socialId'] ?? '@${partnerData['name']?.toString().toLowerCase().replaceAll(' ', '_')}',
                    Icons.person_outline,
                    Colors.purple,
                  ),

                  const SizedBox(height: 30),

                  // Basic Information
                  _buildSectionTitle(
                    isArabic ? 'المعلومات الأساسية' : 'Basic Information',
                    Icons.info_outline,
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    isArabic ? 'العمر' : 'Age',
                    '${partnerData['age']} ${isArabic ? 'سنة' : 'years'}',
                    Icons.cake,
                  ),
                  const Divider(height: 30),
                  _buildDetailRow(
                    isArabic ? 'المدينة' : 'City',
                    partnerData['city'] ?? '',
                    Icons.location_city,
                  ),
                  const Divider(height: 30),
                  _buildDetailRow(
                    isArabic ? 'الحالة' : 'Status',
                    isArabic ? 'متاح للتواصل' : 'Available',
                    Icons.verified,
                  ),

                  const SizedBox(height: 30),

                  // Contact Options Section
                  _buildSectionTitle(
                    isArabic ? 'خيارات التواصل' : 'Contact Options',
                    Icons.connect_without_contact,
                  ),
                  const SizedBox(height: 15),
                  
                  // Chat Button
                  _buildActionButton(
                    context,
                    label: isArabic ? 'بدء محادثة' : 'Start Chat',
                    icon: Icons.chat_bubble,
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Send Message Button
                  _buildActionButton(
                    context,
                    label: isArabic ? 'إرسال رسالة' : 'Send Message',
                    icon: Icons.send,
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                      // This will trigger the quick message dialog in search_screen
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Add to Favorites
                  _buildActionButton(
                    context,
                    label: isArabic ? 'إضافة للمفضلة' : 'Add to Favorites',
                    icon: Icons.favorite,
                    color: Colors.pink,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isArabic
                                ? 'تمت الإضافة إلى المفضلة'
                                : 'Added to favorites',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Privacy Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.privacy_tip, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isArabic
                                ? 'لا يتم مشاركة معلومات الاتصال الشخصية إلا بموافقة الطرفين'
                                : 'Personal contact information is only shared with mutual consent',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 24),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            color: color,
            onPressed: () {
              // Copy to clipboard functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 22),
        const SizedBox(width: 15),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
