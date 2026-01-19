import '../models/enums.dart';
import '../models/user_model.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();

  factory SearchService() {
    return _instance;
  }

  SearchService._internal();

  // Mock user database
  final Map<String, User> _allUsers = {};

  // Calculate compatibility score
  Future<Map<String, dynamic>> calculateCompatibility(
    User currentUser,
    User targetUser,
  ) async {
    try {
      double score = 0;

      // Age compatibility (15 points)
      final ageScore = _calculateAgeScore(currentUser.age, targetUser.age);
      score += ageScore * 0.15;

      // Location compatibility (20 points)
      final locationScore = _calculateLocationScore(
        currentUser.country,
        targetUser.country,
        currentUser.state,
        targetUser.state,
      );
      score += locationScore * 0.20;

      // Education compatibility (15 points)
      final educationScore = _calculateEducationScore(
        currentUser.educationLevel,
        targetUser.educationLevel,
      );
      score += educationScore * 0.15;

      // Marital status compatibility (15 points)
      final maritalScore = _calculateMaritalScore(
        currentUser.maritalStatus,
        targetUser.maritalStatus,
      );
      score += maritalScore * 0.15;

      // Height compatibility (10 points)
      final heightScore = _calculateHeightScore(
        currentUser.heightCm,
        targetUser.heightCm,
      );
      score += heightScore * 0.10;

      // Income compatibility (Estimated from employment) (10 points)
      final incomeScore = _calculateIncomeScore(
        currentUser.employmentStatus,
        targetUser.employmentStatus,
      );
      score += incomeScore * 0.10;

      return {
        'score': (score * 100).toStringAsFixed(1),
        'ageCompatibility': (ageScore * 100).toStringAsFixed(0),
        'locationCompatibility': (locationScore * 100).toStringAsFixed(0),
        'educationCompatibility': (educationScore * 100).toStringAsFixed(0),
        'maritalCompatibility': (maritalScore * 100).toStringAsFixed(0),
        'heightCompatibility': (heightScore * 100).toStringAsFixed(0),
        'incomeCompatibility': (incomeScore * 100).toStringAsFixed(0),
      };
    } catch (e) {
      return {'score': '0', 'error': e.toString()};
    }
  }

  // Search for compatible users
  Future<List<User>> searchCompatibleUsers(
    String currentUserId,
    User currentUser,
  ) async {
    try {
      // Filter users (not the current user, not reserved, not withdrawn)
      final candidates = _allUsers.values
          .where(
            (user) =>
                user.uid != currentUserId &&
                user.accountStatus != AccountStatus.withdrawn &&
                user.accountStatus != AccountStatus.married &&
                user.gender != currentUser.gender,
          ) // Assuming heterosexual matching
          .toList();

      // Sort by compatibility score
      final scored = <(User, double)>[];
      for (var user in candidates) {
        final compat = await calculateCompatibility(currentUser, user);
        final score = double.parse(compat['score'].toString());
        scored.add((user, score));
      }

      scored.sort((a, b) => b.$2.compareTo(a.$2));
      return scored.map((e) => e.$1).toList();
    } catch (e) {
      return [];
    }
  }

  // Score calculations
  double _calculateAgeScore(int age1, int age2) {
    final diff = (age1 - age2).abs();
    if (diff <= 5) return 1.0;
    if (diff <= 10) return 0.75;
    if (diff <= 15) return 0.5;
    return 0.25;
  }

  double _calculateLocationScore(
    String country1,
    String country2,
    String state1,
    String state2,
  ) {
    if (country1 == country2) {
      return state1 == state2 ? 1.0 : 0.7;
    }
    return 0.3;
  }

  double _calculateEducationScore(EducationLevel edu1, EducationLevel edu2) {
    final diff = (edu1.index - edu2.index).abs();
    if (diff == 0) return 1.0;
    if (diff == 1) return 0.75;
    if (diff == 2) return 0.5;
    return 0.25;
  }

  double _calculateMaritalScore(MaritalStatus status1, MaritalStatus status2) {
    if (status1 == status2) return 1.0;
    if ((status1 == MaritalStatus.single && status2 == MaritalStatus.single) ||
        (status1 == MaritalStatus.divorced &&
            status2 == MaritalStatus.divorced)) {
      return 0.9;
    }
    return 0.5;
  }

  double _calculateHeightScore(int height1, int height2) {
    final diff = (height1 - height2).abs();
    if (diff <= 5) return 1.0;
    if (diff <= 10) return 0.75;
    if (diff <= 20) return 0.5;
    return 0.25;
  }

  double _calculateIncomeScore(EmploymentStatus emp1, EmploymentStatus emp2) {
    final status1Value = _getEmploymentValue(emp1);
    final status2Value = _getEmploymentValue(emp2);

    final diff = (status1Value - status2Value).abs();
    if (diff <= 1) return 1.0;
    if (diff <= 2) return 0.75;
    return 0.5;
  }

  int _getEmploymentValue(EmploymentStatus status) {
    switch (status) {
      case EmploymentStatus.governmentEmployee:
        return 4;
      case EmploymentStatus.privateEmployee:
        return 3;
      case EmploymentStatus.selfEmployed:
        return 4;
      case EmploymentStatus.unemployed:
        return 1;
      case EmploymentStatus.retired:
        return 3;
      case EmploymentStatus.noJob:
        return 1;
    }
  }

  // Add user to search database
  void addUser(User user) {
    _allUsers[user.uid] = user;
  }

  // Remove user from search
  void removeUser(String userId) {
    _allUsers.remove(userId);
  }
}
