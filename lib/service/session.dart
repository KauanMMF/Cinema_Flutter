// Importa o pacote para salvar dados simples localmente no dispositivo
import 'package:shared_preferences/shared_preferences.dart';

// Classe responsável por gerenciar a sessão do usuário (login/logout)
class SessionManager {
  // Chaves usadas para salvar os dados no SharedPreferences
  final String _isLoggedInKey = 'isLoggedIn';
  final String _usernameKey = 'username';

  // Cria uma sessão de usuário (salva que está logado e o nome do usuário)
  Future<void> createSession(String username) async {
    final prefs = await SharedPreferences.getInstance(); // Acessa o armazenamento local
    await prefs.setBool(_isLoggedInKey, true);          // Marca como logado
    await prefs.setString(_usernameKey, username);      // Salva o nome do usuário
  }

  // Recupera os dados da sessão (se está logado e o nome do usuário)
  Future<Map<String, dynamic>> getSession() async {
    final prefs = await SharedPreferences.getInstance(); // Acessa o armazenamento local
    return {
      'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false, // Retorna true/false se está logado
      'username': prefs.getString(_usernameKey),            // Retorna o nome do usuário (ou null)
    };
  }

  // Destroi a sessão (faz logout, removendo os dados salvos)
  Future<void> destroySession() async {
    final prefs = await SharedPreferences.getInstance(); // Acessa o armazenamento local
    await prefs.remove(_isLoggedInKey);                 // Remove o status de login
    await prefs.remove(_usernameKey);                   // Remove o nome do usuário
  }
}
