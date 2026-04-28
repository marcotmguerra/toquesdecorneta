import 'package:flutter/material.dart';
import '../data/toque.dart';
import '../widgets/progresso_card.dart';
import '../widgets/toque_card.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        const ProgressoCard(),
        ...toques.map((t) => ToqueCard(toque: t)),
      ],
    );
  }
}
