import 'package:flutter/material.dart';

class FrequenciaPage extends StatelessWidget {
  const FrequenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double porcentagem = 0.9; // 90%

    final List<Map<String, dynamic>> presencas = [
      {"data": "01/04", "presente": true},
      {"data": "02/04", "presente": true},
      {"data": "03/04", "presente": false},
      {"data": "04/04", "presente": true},
      {"data": "05/04", "presente": true},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Frequência'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD RESUMO
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
                    'Presença Total',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(porcentagem * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // BARRA DE PROGRESSO
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: porcentagem,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LISTA
            Expanded(
              child: ListView.builder(
                itemCount: presencas.length,
                itemBuilder: (context, index) {
                  final item = presencas[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item["presente"] ? Icons.check_circle : Icons.cancel,
                        color: item["presente"] ? Colors.green : Colors.red,
                      ),
                      title: Text('Data: ${item["data"]}'),
                      subtitle: Text(item["presente"] ? 'Presente' : 'Faltou'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
