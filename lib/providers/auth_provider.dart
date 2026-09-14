import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Map<String, dynamic>? _user;
  bool _isLoading = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<bool> login(
      String username,
      String password,
      ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.login(
        username,
        password,
      );

      return _user != null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // RESTORE USER
  // ---------------------------------------------------------

  Future<bool> restoreUser(String username) async {
    _user = await _authService.getUser(username);

    notifyListeners();

    return _user != null;
  }

  // ---------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------

  void logout() {
    _user = null;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------

  Future<int> register(
      String username,
      String password,
      ) {
    return _authService.register(
      username,
      password,
    );
  }
}