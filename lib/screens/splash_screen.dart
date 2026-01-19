import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({super.key, this.isLoggedIn = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String language;

  @override
  void initState() {
    super.initState();
    language = 'ar'; // Default to Arabic
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade100, Colors.pink.shade50],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Language Selection
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() => language = value);
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'ar',
                      child: Text('العربية 🇸🇦'),
                    ),
                    const PopupMenuItem(
                      value: 'en',
                      child: Text('English 🇬🇧'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      isArabic ? 'العربية 🇸🇦' : 'English 🇬🇧',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Main Content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heart with Flag Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 80,
                              color: Colors.red,
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Text(
                                '🇩🇿',
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      isArabic
                          ? 'مرحبًا بك في تطبيق زواج\nZAWADJ'
                          : 'Welcome to ZAWADJ\nMarriage App',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Welcome Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        isArabic
                            ? 'هذا التطبيق مخصص لمن أراد إكمال نصف دينه.\nالتفكير في الزواج لا يخضع للمعادلات الرياضية.\nزواج ليلة تدبيره عام.\nدير النية وبات برا في الطريق\nفاذا عزمت فتوكل على الله.'
                            : 'This application is intended for those who want to complete half of their faith.\nThinking about marriage is not subject to mathematical equations.\nA marriage whose night plan is wise.\nSet your intention and be on the road.\nSo if you are determined, rely on Allah.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Continue Button
            Padding(
              padding: const EdgeInsets.all(30),
              child: CustomButton(
                label: isArabic ? 'واصل' : 'Continue',
                onPressed: () {
                  if (widget.isLoggedIn) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    Navigator.pushReplacementNamed(context, '/auth');
                  }
                },
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
