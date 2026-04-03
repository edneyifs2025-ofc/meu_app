import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'notas_page.dart';
import 'frequencia_page.dart';
import 'avisos_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final pages = const [HomePage(), NotasPage(), FrequenciaPage(), AvisosPage()];
  final titles = ['Início', 'Notas', 'Frequência', 'Avisos'];

  Future<void> logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.indigo,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Notas'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Freq.'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Avisos',
          ),
        ],
      ),
    );
  }
}
