import 'package:flutter/material.dart';

class AvisosPage extends StatelessWidget {
  const AvisosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> avisos = [
      {
        "titulo": "Reunião de Pais",
        "descricao": "Sexta-feira às 19h na escola",
        "data": "05/04/2026",
        "importante": true,
      },
      {
        "titulo": "Prova de Matemática",
        "descricao": "Conteúdo: Álgebra e Geometria",
        "data": "10/04/2026",
        "importante": true,
      },
      {
        "titulo": "Entrega de Trabalhos",
        "descricao": "História e Português",
        "data": "12/04/2026",
        "importante": false,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Avisos'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: avisos.length,
        itemBuilder: (context, index) {
          final aviso = avisos[index];
          final bool importante = aviso["importante"];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: importante ? Colors.red.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: importante ? Colors.red : Colors.blue,
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  importante ? Icons.warning : Icons.notifications,
                  color: importante ? Colors.red : Colors.blue,
                  size: 30,
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aviso["titulo"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(aviso["descricao"]),
                      const SizedBox(height: 5),
                      Text(
                        "📅 ${aviso["data"]}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
