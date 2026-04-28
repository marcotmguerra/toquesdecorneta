import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme.dart';
import '../../widgets/app_card.dart';
import 'quantidade_screen.dart';

class SimuladoScreen extends StatelessWidget {
  const SimuladoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Treino',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: ac.text1)),
              const SizedBox(height: 4),
              Text('Escolha o modo', style: TextStyle(color: ac.text2, fontSize: 14)),
              const SizedBox(height: 20),
              _ModoBtn(
                icon: Icons.headphones,
                titulo: 'Modo Clássico',
                subtitulo: 'Ouça e identifique o toque',
                onTap: () {
                  context.read<AppProvider>().setModo(ModoSimulado.classico);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const QuantidadeScreen()));
                },
              ),
              const SizedBox(height: 12),
              _ModoBtn(
                icon: Icons.checklist,
                titulo: 'Múltipla Escolha',
                subtitulo: 'Escolha entre 4 alternativas',
                onTap: () {
                  context.read<AppProvider>().setModo(ModoSimulado.multipla);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const QuantidadeScreen()));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModoBtn extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  const _ModoBtn({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: ac.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                  color: ac.accentBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: ac.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15, color: ac.text1)),
                  Text(subtitulo, style: TextStyle(fontSize: 12, color: ac.text2)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: ac.text3),
          ],
        ),
      ),
    );
  }
}
