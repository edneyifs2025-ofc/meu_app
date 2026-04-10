import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
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

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    // 🔥 ESCUTA O RETORNO DO GOV.BR (DEEP LINK)
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (uri != null && uri.host == 'login') {
        final code = uri.queryParameters['code'];

        print("Código recebido: $code");

        // Aqui você pode validar com API depois
        await AuthService.login();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    matriculaController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  // ✅ LOGIN COM MATRÍCULA
  Future<void> loginMatriculaSenha() async {
    final matricula = matriculaController.text.trim();
    final senha = senhaController.text.trim();

    if (matricula.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha matrícula e senha')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao fazer login')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // 🌐 LOGIN GOV.BR CORRETO
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

      if (!abriu) throw 'Erro ao abrir';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao acessar o GOV.BR')),
      );
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
                      // 🔢 MATRÍCULA
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

                      // 🔒 SENHA
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

                      // 🔐 LOGIN NORMAL
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

                      // 🌐 GOV.BR
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
