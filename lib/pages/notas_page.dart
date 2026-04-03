import 'package:flutter/material.dart';

class NotasPage extends StatelessWidget {
  const NotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notas = [
      {"materia": "Matemática", "nota": 8.5},
      {"materia": "Português", "nota": 7.0},
      {"materia": "História", "nota": 9.0},
    ];

    double media =
        notas.map((e) => e["nota"] as double).reduce((a, b) => a + b) /
        notas.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Notas'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD DA MÉDIA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Média Geral',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    media.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LISTA DE NOTAS
            Expanded(
              child: ListView.builder(
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  final item = notas[index];
                  final nota = item["nota"] as double;

                  Color cor;
                  if (nota >= 7) {
                    cor = Colors.green;
                  } else if (nota >= 5) {
                    cor = Colors.orange;
                  } else {
                    cor = Colors.red;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cor,
                        child: const Icon(Icons.book, color: Colors.white),
                      ),
                      title: Text(item["materia"]),
                      subtitle: const Text('Nota final'),
                      trailing: Text(
                        nota.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
