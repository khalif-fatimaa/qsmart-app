import '../models/models.dart';
import 'qsmart_api.dart';
import 'auth_state.dart';

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });
}

class AuthService {
  static User? currentUser;

  final QSmartApi _api = QSmartApi.instance;

  Future<User?> login(LoginRequest request) async {
    // 1) Call backend /login to get JWT and store in AuthState.accessToken
    await _api.login(
      request.email.trim(),
      request.password,
    );

    final String? token = AuthState.accessToken;
    if (token == null || token.isEmpty) {
      return null;
    }

    // 2) Fetch users from backend and find the one matching email
    final List<User> allUsers = await _api.getUsers(token);
    final String lower = request.email.trim().toLowerCase();

    final User user = allUsers.firstWhere(
      (User u) => u.email.toLowerCase() == lower,
      orElse: () => const User(
        userId: '',
        name: '',
        email: '',
        createdAt: null,
      ),
    );

    if (user.userId.isEmpty) {
      // login succeeded but user not found in /api/user – treat as failure
      return null;
    }

    currentUser = user;
    AuthState.currentUser = user;
    return currentUser;
  }
}
