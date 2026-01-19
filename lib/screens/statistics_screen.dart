import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late String language;

  Map<String, int> stats = {
    'total': 0,
    'available': 0,
    'serious': 0,
    'married': 0,
    'withdrawn': 0,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    language = 'ar';
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      int total = usersSnapshot.docs.length;
      int available = 0;
      int serious = 0;
      int married = 0;
      int withdrawn = 0;

      for (var doc in usersSnapshot.docs) {
        final status = doc.data()['accountStatus'];
        switch (status) {
          case 'available':
            available++;
            break;
          case 'inSeriousProcess':
            serious++;
            break;
          case 'married':
            married++;
            break;
          case 'withdrawn':
            withdrawn++;
            break;
          default:
            available++; // Default to available if no status
        }
      }

      if (mounted) {
        setState(() {
          stats = {
            'total': total,
            'available': available,
            'serious': serious,
            'married': married,
            'withdrawn': withdrawn,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل الإحصائيات / Error: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
      

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? ArabicStrings.statistics : EnglishStrings.statistics,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : stats['total'] == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 60, color: Colors.grey),
                      const SizedBox(height: 20),
                      Text(
                        isArabic 
                            ? 'لا توجد بيانات حالياً\nالإحصائيات ستظهر عند تسجيل المستخدمين'
                            : 'No data available yet\nStatistics will appear when users register',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          Text(
            isArabic ? 'إحصائيات التطبيق' : 'App Statistics',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Total Users
          _buildStatCard(
            icon: Icons.favorite_outline,
            color: Colors.grey,
            title: isArabic ? ArabicStrings.totalUsers : EnglishStrings.totalUsers,
            value: stats['total'].toString(),
            emoji: '🤍',
          ),
          const SizedBox(height: 15),

          // Available Users
          _buildStatCard(
            icon: Icons.favorite,
            color: Colors.green,
            title: isArabic ? ArabicStrings.availableUsers : EnglishStrings.availableUsers,
            value: stats['available'].toString(),
            emoji: '💚',
          ),
          const SizedBox(height: 15),

          // Serious Process Users
          _buildStatCard(
            icon: Icons.favorite,
            color: Colors.orange,
            title: isArabic ? ArabicStrings.seriousProcessUsers : EnglishStrings.seriousProcessUsers,
            value: stats['serious'].toString(),
            emoji: '🧡',
          ),
          const SizedBox(height: 15),

          // Married Users
          _buildStatCard(
            icon: Icons.favorite,
            color: Colors.red,
            title: isArabic ? ArabicStrings.marriedUsers : EnglishStrings.marriedUsers,
            value: stats['married'].toString(),
            emoji: '❤️',
          ),
          const SizedBox(height: 15),

          // Withdrawn Users
          _buildStatCard(
            icon: Icons.favorite,
            color: Colors.black,
            title: isArabic ? ArabicStrings.withdrawnUsers : EnglishStrings.withdrawnUsers,
            value: stats['withdrawn'].toString(),
            emoji: '🖤',
          ),
          const SizedBox(height: 30),

          // Chart Summary
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
                  Text(
                    isArabic ? 'الملخص' : 'Summary',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStatRow(
                    isArabic ? 'نسبة الحسابات المتاحة' : 'Available Accounts %',
                    stats['total']! > 0 
                        ? '${((stats['available']! / stats['total']!) * 100).toStringAsFixed(1)}%'
                        : '0%',
                  ),
                  const SizedBox(height: 10),
                  _buildStatRow(
                    isArabic ? 'نسبة المرتبطين' : 'Serious Process %',
                    stats['total']! > 0
                        ? '${((stats['serious']! / stats['total']!) * 100).toStringAsFixed(1)}%'
                        : '0%',
                  ),
                  const SizedBox(height: 10),
                  _buildStatRow(
                    isArabic ? 'نسبة المتزوجين' : 'Married %',
                    stats['total']! > 0
                        ? '${((stats['married']! / stats['total']!) * 100).toStringAsFixed(1)}%'
                        : '0%',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String emoji,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
