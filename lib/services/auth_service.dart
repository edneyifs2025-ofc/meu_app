import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyLogin = 'logado';
  static const String _keyUser = 'usuario';

  // 🔐 FAZ LOGIN
  static Future<void> login({String? usuario}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyLogin, true);

    if (usuario != null) {
      await prefs.setString(_keyUser, usuario);
    }
  }

  // ✅ VERIFICA SE ESTÁ LOGADO
  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLogin) ?? false;
  }

  // 👤 PEGA NOME DO USUÁRIO
  static Future<String?> getUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }

  // 🚪 LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogin);
    await prefs.remove(_keyUser);
  }
}
