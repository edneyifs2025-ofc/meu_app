import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import '../services/auth_service.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  bool _jaNavegou = false;

  @override
  void initState() {
    super.initState();
    _initDeepLink();
    _verificarLogin();
  }

  // 🔗 ESCUTA O RETORNO DO GOV.BR
  void _initDeepLink() {
    _sub = _appLinks.uriLinkStream.listen(
      (Uri uri) async {
        if (!_jaNavegou && uri.host == 'login') {
          _jaNavegou = true;

          debugPrint("Retorno do login: $uri");

          try {
            await AuthService.login();

            if (!mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          } catch (e) {
            _irParaLogin();
          }
        }
      },
      onError: (err) {
        debugPrint("Erro no deep link: $err");
      },
    );
  }

  // 🔐 VERIFICA LOGIN
  Future<void> _verificarLogin() async {
    bool logado = await AuthService.isLogado();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _jaNavegou) return;

    _jaNavegou = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => logado ? const MainPage() : const LoginPage(),
      ),
    );
  }

  void _irParaLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _sub?.cancel(); // 🔥 MUITO IMPORTANTE
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
