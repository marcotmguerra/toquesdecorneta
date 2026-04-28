import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/storage.dart';
import '../theme.dart';
import 'home_screen.dart';

class _Slide {
  final IconData icon;
  final String titulo;
  final String texto;
  const _Slide(this.icon, this.titulo, this.texto);
}

const _slides = [
  _Slide(
    Icons.music_note,
    'Bem-vindo aos\nToques de Corneta',
    'Aprenda a identificar os 27 toques de corneta militares. Cada toque tem um bizu — uma frase que ajuda a memorizar o som.',
  ),
  _Slide(
    Icons.psychology,
    'Treino\nInteligente',
    'O app usa repetição espaçada: toques que você erra voltam mais cedo, enquanto os que você domina aparecem menos.',
  ),
  _Slide(
    Icons.track_changes,
    'Dois modos\nde treino',
    'Modo Clássico: ouça e identifique o toque.\n\nMúltipla Escolha: 4 alternativas com feedback imediato e dica do bizu ao errar.',
  ),
  _Slide(
    Icons.info_outline,
    'Aba\nInformações',
    'Na aba Informações você encontra configurações do sistema — como sons e vibração — e suas métricas de desempenho por toque.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;

  void _concluir() async {
    await context.read<Storage>().concluirOnboarding();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final slide = _slides[_page];
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header: dots + skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(_slides.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width:  i == _page ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i == _page ? ac.accent : ac.border,
                      ),
                    )),
                  ),
                  if (!isLast)
                    TextButton(
                      onPressed: _concluir,
                      child: Text('Pular', style: TextStyle(color: ac.text2)),
                    ),
                ],
              ),

              const Spacer(),

              // Icon
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: ac.accentBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(slide.icon, size: 48, color: ac.accent),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                slide.titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w700,
                  color: ac.text1, height: 1.25,
                ),
              ),

              const SizedBox(height: 16),

              // Body text
              Text(
                slide.texto,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: ac.text2, height: 1.5),
              ),

              // Domain badges on slide 2
              if (_page == 1) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Badge('Aprendendo', ac.badgeAprendendo),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.arrow_forward, size: 16),
                    ),
                    _Badge('Bom', ac.badgeBom),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.arrow_forward, size: 16),
                    ),
                    _Badge('Dominado', ac.badgeDominado),
                  ],
                ),
              ],

              const Spacer(),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLast
                      ? _concluir
                      : () => setState(() => _page++),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLast) const Icon(Icons.rocket_launch, size: 18),
                      if (isLast) const SizedBox(width: 8),
                      Text(isLast ? 'Começar' : 'Próximo →'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
