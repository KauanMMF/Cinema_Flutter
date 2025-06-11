import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String _isLoggedInKey = 'isLoggedIn';
  final String _usernameKey = 'username';

  Future<void> createSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_usernameKey, username);
  }

  Future<Map<String, dynamic>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
      'username': prefs.getString(_usernameKey),
    };
  }

  Future<void> destroySession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
  }
}
