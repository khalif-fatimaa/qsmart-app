import '../models/models.dart';

class AuthState {
  // Private backing fields
  static String? _accessToken;
  static User? _currentUser;

  // Public getters
  static String? get accessToken => _accessToken;
  static User? get currentUser => _currentUser;

  static set accessToken(String? value) => _accessToken = value;
  static set currentUser(User? value) => _currentUser = value;

  // Convenience flag
  static bool get isAuthenticated => _accessToken != null;

  // Used right after login
  static void setSession({
    required String token,
    required User user,
  }) {
    _accessToken = token;
    _currentUser = user;
  }

  // Used on logout
  static void logout() {
    _accessToken = null;
    _currentUser = null;
  }
}
