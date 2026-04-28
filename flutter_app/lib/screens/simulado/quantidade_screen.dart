import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/toque.dart';
import '../../providers/app_provider.dart';
import '../../theme.dart';
import '../../widgets/app_card.dart';
import 'questao_screen.dart';

class QuantidadeScreen extends StatefulWidget {
  const QuantidadeScreen({super.key});

  @override
  State<QuantidadeScreen> createState() => _QuantidadeScreenState();
}

class _QuantidadeScreenState extends State<QuantidadeScreen> {
  final _ctrl = TextEditingController(text: '10');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _iniciar() {
    final provider = context.read<AppProvider>();
    final total = (int.tryParse(_ctrl.text) ?? 10).clamp(1, toques.length);
    provider.iniciarProva(total);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QuestaoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final titulo = context.watch<AppProvider>().modo == ModoSimulado.classico
        ? 'Modo Clássico'
        : 'Múltipla Escolha';

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Text('Quantas questões?',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20, color: ac.text1)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ac.accentBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.psychology, color: ac.accent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Toques mais fracos e esquecidos aparecem com mais frequência',
                          style: TextStyle(fontSize: 12, color: ac.accent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _ctrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700, color: ac.text1),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ac.accent, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ac.accent, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('de ${toques.length}', style: TextStyle(color: ac.text2)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [5, 10, toques.length].map((n) {
                    final label = n == toques.length ? 'Todas' : '$n';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        onPressed: () => setState(() => _ctrl.text = '$n'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ac.accent,
                          side: BorderSide(color: ac.accent),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(label,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _iniciar,
                    icon: const Icon(Icons.play_circle_outline, size: 20),
                    label: const Text('Iniciar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
