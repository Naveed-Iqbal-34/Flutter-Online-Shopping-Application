import '../database/database_helper.dart';

class AuthService {
  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<Map<String, dynamic>?> login(
      String username,
      String password,
      ) {
    return _database.loginUser(
      username,
      password,
    );
  }

  Future<int> register(
      String username,
      String password,
      ) {
    return _database.registerUser(
      username,
      password,
    );
  }

  Future<Map<String, dynamic>?> getUser(
      String username,
      ) {
    return _database.getUser(username);
  }
}