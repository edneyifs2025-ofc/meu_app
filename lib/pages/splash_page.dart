import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initDeepLink();
    verificarLogin();
  }

  // 🔗 Escuta o retorno do GOV.BR
  void initDeepLink() {
    uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        debugPrint("Retorno do login: $uri");

        // Aqui você pode salvar que o usuário está logado
        await AuthService.setLogado(true);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    });
  }

  // 🔐 Verifica se já está logado
  void verificarLogin() async {
    bool logado = await AuthService.isLogado();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => logado ? const MainPage() : const LoginPage(),
      ),
    );
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
