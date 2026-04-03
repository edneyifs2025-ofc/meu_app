import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String keyLogin = 'logado';

  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyLogin, true);
  }

  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyLogin) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
