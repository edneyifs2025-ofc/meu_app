import 'package:flutter/material.dart';
import 'pages/splash_page.dart'; // Importa a SplashPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestão Escolar',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const SplashPage(), // Tela inicial
    );
  }
}
