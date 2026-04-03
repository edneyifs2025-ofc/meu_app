import 'package:flutter/material.dart';

class AvisosPage extends StatelessWidget {
  const AvisosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: const [
        ListTile(title: Text('Reunião sexta-feira')),
        ListTile(title: Text('Prova na próxima semana')),
      ],
    );
  }
}
