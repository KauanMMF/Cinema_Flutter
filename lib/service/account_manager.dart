import '../model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManager {
  String _getUserKey(String email) => 'user_data_$email';

  Future<bool> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(user.email);

    if (prefs.containsKey(userKey)) {
      print('Erro: Email já cadastrado.');
      return false;
    }

    final String userJson = user.toJson();
    await prefs.setString(userKey, userJson);
    print('Usuário ${user.name} cadastrado com sucesso!');
    return true;
  }

  Future<User?> getUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(email);

    final String? userJson = prefs.getString(userKey);

    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }
}
