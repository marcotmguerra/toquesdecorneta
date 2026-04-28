import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/metrica.dart';
import '../data/toque.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import 'app_card.dart';

class ProgressoCard extends StatelessWidget {
  const ProgressoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final metricas = context.watch<AppProvider>().metricas;
    final total = toques.length;

    var aprendendo = 0, bom = 0, dominado = 0;
    for (final t in toques) {
      switch (metricas[t.id]?.dominio) {
        case Dominio.bom:      bom++;      break;
        case Dominio.dominado: dominado++; break;
        default:               aprendendo++;
      }
    }

    final pct = ((dominado / total) * 100).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seu Progresso',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: ac.text1)),
              Text('$pct% dominado',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: ac.accent)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(children: [
                _Seg(aprendendo / total, ac.badgeAprendendo),
                _Seg(bom        / total, ac.badgeBom),
                _Seg(dominado   / total, ac.badgeDominado),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Leg('Aprendendo', aprendendo, ac.badgeAprendendo, ac),
              _Leg('Bom',        bom,        ac.badgeBom,        ac),
              _Leg('Dominado',   dominado,   ac.badgeDominado,   ac),
            ],
          ),
        ],
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  final double fraction;
  final Color color;
  const _Seg(this.fraction, this.color);

  @override
  Widget build(BuildContext context) => Flexible(
    flex: (fraction * 1000).round().clamp(1, 1000),
    child: Container(color: color),
  );
}

class _Leg extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final AppColors ac;
  const _Leg(this.label, this.count, this.color, this.ac);

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 4),
    Text('$label ', style: TextStyle(fontSize: 12, color: ac.text2)),
    Text('$count',  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ac.text1)),
  ]);
}
