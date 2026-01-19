class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  final Map<String, dynamic> _prefs = {};

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<void> init() async {
    // Mock initialization - ready for SharedPreferences integration
  }

  // User Authentication
  Future<void> saveUserId(String userId) async {
    _prefs['userId'] = userId;
  }

  String? getUserId() {
    return _prefs['userId'];
  }

  Future<void> saveToken(String token) async {
    _prefs['authToken'] = token;
  }

  String? getToken() {
    return _prefs['authToken'];
  }

  Future<void> clearAuth() async {
    _prefs.remove('userId');
    _prefs.remove('authToken');
  }

  bool isLoggedIn() {
    return _prefs['userId'] != null;
  }

  // Language
  Future<void> setLanguage(String language) async {
    _prefs['language'] = language;
  }


  String getLanguage() {
    return _prefs['language'] ?? 'en';
  }

  // First Time User
  Future<void> setFirstTime(bool isFirst) async {
    _prefs['firstTime'] = isFirst;
  }

  bool isFirstTime() {
    return _prefs['firstTime'] ?? true;
  }

  // Profile Complete
  Future<void> setProfileComplete(bool complete) async {
    _prefs['profileComplete'] = complete;
  }

  bool isProfileComplete() {
    return _prefs['profileComplete'] ?? false;
  }

  // Clear All Data
  Future<void> clearAll() async {
    _prefs.clear();
  }
}
