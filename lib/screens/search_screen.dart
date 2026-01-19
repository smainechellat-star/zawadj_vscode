import 'package:flutter/material.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import 'partner_preview_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String language;
  int currentIndex = 0;

  // Mock matched users
  final List<Map<String, dynamic>> matchedUsers = [
    {'name': 'فاطمة', 'age': 25, 'city': 'الجزائر', 'score': 85, 'image': '👩'},
    {'name': 'ليلى', 'age': 23, 'city': 'وهران', 'score': 78, 'image': '👩'},
    {'name': 'نور', 'age': 26, 'city': 'سطيف', 'score': 72, 'image': '👩'},
  ];

  @override
  void initState() {
    super.initState();
    language = 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
      

    if (matchedUsers.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: isArabic ? ArabicStrings.autoSearch : EnglishStrings.autoSearch,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                isArabic ? 'لا توجد نتائج' : 'No results found',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    final user = matchedUsers[currentIndex];

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? ArabicStrings.autoSearch : EnglishStrings.autoSearch,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe from right to left (next partner)
          if (details.primaryVelocity! < 0) {
            if (currentIndex < matchedUsers.length - 1) {
              setState(() => currentIndex++);
            }
          }
          // Swipe from left to right (previous partner)
          else if (details.primaryVelocity! > 0) {
            if (currentIndex > 0) {
              setState(() => currentIndex--);
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // User Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartnerPreviewScreen(
                        partnerData: user,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar
                      Text(user['image'], style: const TextStyle(fontSize: 100)),
                      const SizedBox(height: 20),
                      // Name & Age
                      Text(
                        '${user['name']}, ${user['age']}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // City
                      Text(
                        user['city'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Compatibility Score
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${isArabic ? 'التوافق: ' : 'Compatibility: '}${user['score']}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
              const SizedBox(height: 30),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decline
                FloatingActionButton(
                  onPressed: () {
                    if (currentIndex < matchedUsers.length - 1) {
                      setState(() => currentIndex++);
                    }
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close, size: 30),
                ),
                const SizedBox(width: 20),
                // Chat Button
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.chat, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 20),
                // Favorite (Heart)
                FloatingActionButton(
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
                  backgroundColor: Colors.pink,
                  child: const Icon(
                    Icons.favorite,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Send Quick Message Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showQuickMessageDialog(context, isArabic);
                },
                icon: const Icon(Icons.send),
                label: Text(isArabic ? 'إرسال رسالة' : 'Send Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Index indicator
            Text(
              '${currentIndex + 1}/${matchedUsers.length}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 10),
            // Swipe instruction
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back, color: Colors.grey, size: 20),
                const SizedBox(width: 10),
                Text(
                  isArabic ? 'اسحب للتنقل' : 'Swipe to navigate',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showQuickMessageDialog(BuildContext context, bool isArabic) {
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'إرسال رسالة' : 'Send Message'),
        content: TextField(
          controller: messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: isArabic ? 'اكتب رسالتك هنا...' : 'Type your message here...',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic ? 'تم إرسال الرسالة بنجاح' : 'Message sent successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Here you would normally call ChatService to send the message
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(isArabic ? 'إرسال' : 'Send'),
          ),
        ],
      ),
    );
  }
}
