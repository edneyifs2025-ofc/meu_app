import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import '../services/auth_service.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  bool obscurePassword = true;

  final matriculaController = TextEditingController();
  final senhaController = TextEditingController();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  bool _jaNavegou = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  // 🔥 ESCUTA O RETORNO DO GOV.BR
  void _initDeepLinkListener() {
    _sub = _appLinks.uriLinkStream.listen(
      (Uri uri) async {
        if (!_jaNavegou && uri.host == 'login') {
          _jaNavegou = true;

          final code = uri.queryParameters['code'];
          debugPrint("Código recebido: $code");

          try {
            await AuthService.login();

            if (!mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          } catch (e) {
            _showError('Erro ao processar login GOV.BR');
          }
        }
      },
      onError: (err) {
        debugPrint('Erro no deep link: $err');
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    matriculaController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  // 🔴 ERRO
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ✅ LOGIN NORMAL
  Future<void> loginMatriculaSenha() async {
    final matricula = matriculaController.text.trim();
    final senha = senhaController.text.trim();

    if (matricula.isEmpty || senha.isEmpty) {
      _showError('Preencha matrícula e senha');
      return;
    }

    setState(() => loading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      await AuthService.login();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } catch (e) {
      _showError('Erro ao fazer login');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // 🌐 LOGIN GOV.BR
  Future<void> loginGov() async {
    final Uri url = Uri.parse(
      'https://sso.acesso.gov.br/authorize'
      '?client_id=SEU_CLIENT_ID'
      '&response_type=code'
      '&redirect_uri=meuapp://login'
      '&scope=openid+profile+email',
    );

    try {
      final bool abriu = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!abriu) throw Exception('Não abriu URL');
    } catch (e) {
      _showError('Erro ao acessar o GOV.BR');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.school, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'Gestão Escolar',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: matriculaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Matrícula',
                          prefixIcon: const Icon(Icons.badge),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: senhaController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Esqueceu a senha?'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: loginMatriculaSenha,
                              child: const Text('Entrar'),
                            ),
                      const SizedBox(height: 15),
                      const Text('ou'),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.account_balance),
                        label: const Text('Entrar com GOV.BR'),
                        onPressed: loginGov,
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Criar uma conta'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
