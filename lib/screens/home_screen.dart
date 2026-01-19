import 'package:flutter/material.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import '../models/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String language;
  int _selectedIndex = 0;

  // Mock data
  final String userName = 'أحمد سمية';
  final AccountStatus accountStatus = AccountStatus.available;
  final int profileViews = 15;

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
        title: isArabic ? ArabicStrings.home : EnglishStrings.home,
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic
                                        ? ArabicStrings.userName
                                        : EnglishStrings.userName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Account Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isArabic
                                    ? ArabicStrings.accountStatus
                                    : EnglishStrings.accountStatus,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                              StatusIndicator(
                                status: isArabic
                                    ? ArabicStrings.available
                                    : EnglishStrings.available,
                                color: Colors.green,
                                icon: Icons.favorite,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Profile Views
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.visibility, color: Colors.blue),
                      title: Text(isArabic
                          ? ArabicStrings.profileViews
                          : EnglishStrings.profileViews),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profileViews.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Quick Actions
                  Text(
                    isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildActionCard(
                        icon: Icons.search,
                        label: isArabic
                            ? ArabicStrings.autoSearch
                            : EnglishStrings.autoSearch,
                        color: Colors.purple,
                        onTap: () {
                          Navigator.pushNamed(context, '/search');
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.message,
                        label: isArabic
                            ? ArabicStrings.messages
                            : EnglishStrings.messages,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.person,
                        label: isArabic
                            ? ArabicStrings.profile
                            : EnglishStrings.profile,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.settings,
                        label: isArabic
                            ? ArabicStrings.settingsScreen
                            : EnglishStrings.settingsScreen,
                        color: Colors.green,
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/chat');
              break;
            case 2:
              Navigator.pushNamed(context, '/search');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: isArabic ? ArabicStrings.home : EnglishStrings.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mail),
            label: isArabic ? ArabicStrings.inbox : EnglishStrings.inbox,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label:
                isArabic ? ArabicStrings.autoSearch : EnglishStrings.autoSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: isArabic
                ? ArabicStrings.settingsScreen
                : EnglishStrings.settingsScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
