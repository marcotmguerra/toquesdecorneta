import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../audio_service.dart';
import '../data/metrica.dart';
import '../data/srs.dart';
import '../data/toque.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import 'app_card.dart';

class ToqueCard extends StatefulWidget {
  final Toque toque;
  const ToqueCard({super.key, required this.toque});

  @override
  State<ToqueCard> createState() => _ToqueCardState();
}

class _ToqueCardState extends State<ToqueCard> {
  bool _playing = false;
  StreamSubscription<PlayerState>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = AudioService.instance.stateStream.listen((_) {
      if (mounted) {
        setState(() => _playing = AudioService.instance.isPlaying(widget.toque.audio));
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _toggle() async {
    await AudioService.instance.toggle(widget.toque.audio);
    if (mounted) {
      setState(() => _playing = AudioService.instance.isPlaying(widget.toque.audio));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final m = context.watch<AppProvider>().getMetrica(widget.toque.id);
    final total = m.acertos + m.erros;
    final taxa = total > 0 ? ((m.acertos / total) * 100).round() : null;
    final quando = tempoRelativo(m.ultimaVez);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: ac.accentBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.music_note, color: ac.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.toque.nome,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: ac.text1)),
                    if (widget.toque.bizu.isNotEmpty)
                      Text(widget.toque.bizu,
                          style: TextStyle(fontSize: 12, color: ac.text2)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 4,
            children: [
              _DominioBadge(m.dominio, ac),
              if (taxa != null) _InfoChip('$taxa% acerto', ac),
              if (m.sequencia >= 2) _InfoChip('🔥 ${m.sequencia} seguidos', ac),
              if (quando.isNotEmpty) _InfoChip(quando, ac),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _toggle,
              icon: Icon(_playing ? Icons.stop : Icons.play_arrow, size: 18),
              label: Text(_playing ? 'Reproduzindo...' : 'Reproduzir'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DominioBadge extends StatelessWidget {
  final Dominio dominio;
  final AppColors ac;
  const _DominioBadge(this.dominio, this.ac);

  Color get _color {
    switch (dominio) {
      case Dominio.aprendendo: return ac.badgeAprendendo;
      case Dominio.bom:        return ac.badgeBom;
      case Dominio.dominado:   return ac.badgeDominado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(dominio.label,
          style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final AppColors ac;
  const _InfoChip(this.label, this.ac);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: ac.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: ac.text2, fontSize: 11)),
    );
  }
}
