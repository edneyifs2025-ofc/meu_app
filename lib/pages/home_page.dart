import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget card(IconData icon, String titulo, Color cor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: cor),
            const SizedBox(height: 10),
            Text(titulo),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          card(Icons.school, 'Notas', Colors.blue),
          card(Icons.check, 'Frequência', Colors.green),
          card(Icons.notifications, 'Avisos', Colors.orange),
          card(Icons.person, 'Perfil', Colors.indigo),
        ],
      ),
    );
  }
}
