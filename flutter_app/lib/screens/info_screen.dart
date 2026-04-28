import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/storage.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
import '../widgets/progresso_card.dart';
import 'onboarding_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final provider = context.watch<AppProvider>();

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Image.asset(
          'assets/images/pelotao.jpg',
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12),

        const ProgressoCard(),

        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sobre o App',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: ac.text1)),
              const SizedBox(height: 8),
              Text(
                'Este aplicativo foi desenvolvido para auxiliar os alunos do '
                'Pelotão Delta - CEFS 2026 na memorização dos toques de corneta militares.\n\n'
                'A prática através do simulado ajuda na fixação dos bizus e na '
                'agilidade de resposta durante as atividades e na prova.',
                style: TextStyle(color: ac.text2, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),

        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configurações',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: ac.text1)),
              const SizedBox(height: 12),
              _ToggleRow(
                titulo: 'Som',
                subtitulo: 'Efeitos sonoros ao responder',
                valor: provider.som,
                onChanged: (_) => provider.toggleSom(),
              ),
              const Divider(),
              _ToggleRow(
                titulo: 'Vibração',
                subtitulo: 'Feedback háptico ao responder',
                valor: provider.haptico,
                onChanged: (_) => provider.toggleHaptico(),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber, color: Color(0xFFF5A623), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Aviso de Estudo',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                      SizedBox(height: 4),
                      Text(
                        'Esta ferramenta é para fins educacionais. Os toques seguem o padrão '
                        'regulamentar, mas sempre consulte o instrutor do seu pelotão.',
                        style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Text('DESENVOLVIDO POR',
                  style: TextStyle(fontSize: 11, color: ac.text3, letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text('soulTech',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: ac.text1)),
              Text('Versão 2.7.3 (2026)',
                  style: TextStyle(fontSize: 12, color: ac.text2)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await context.read<Storage>().resetarOnboarding();
                  if (context.mounted) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                  }
                },
                child: Text('Ver introdução', style: TextStyle(color: ac.accent)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final bool valor;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: ac.text1)),
              Text(subtitulo, style: TextStyle(fontSize: 12, color: ac.text2)),
            ],
          ),
        ),
        Switch(value: valor, onChanged: onChanged, activeThumbColor: ac.accent),
      ],
    );
  }
}
