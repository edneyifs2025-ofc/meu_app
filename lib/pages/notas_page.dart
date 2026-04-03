import 'package:flutter/material.dart';

class NotasPage extends StatelessWidget {
  const NotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: const [
        ListTile(title: Text('Matemática - 8.5')),
        ListTile(title: Text('Português - 7.0')),
        ListTile(title: Text('História - 9.0')),
      ],
    );
  }
}
