import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../audio_service.dart';
import '../../data/toque.dart';
import '../../providers/app_provider.dart';
import '../../theme.dart';
import '../../widgets/app_card.dart';
import 'simulado_screen.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class QuestaoScreen extends StatelessWidget {
  const QuestaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<AppProvider>().modo == ModoSimulado.multipla
        ? const _QuestaoMCScreen()
        : const _QuestaoClassicaScreen();
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _ProgressoTopo extends StatelessWidget {
  final int indice;
  final int total;
  const _ProgressoTopo(this.indice, this.total);

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? indice / total : 0,
                minHeight: 6,
                backgroundColor: ac.border,
                valueColor: AlwaysStoppedAnimation(ac.accent),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ac.accentBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.track_changes, size: 12, color: ac.accent),
                const SizedBox(width: 4),
                Text('Adaptativo',
                    style: TextStyle(
                        fontSize: 11, color: ac.accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioBtn extends StatefulWidget {
  final Toque toque;
  const _AudioBtn(this.toque);

  @override
  State<_AudioBtn> createState() => _AudioBtnState();
}

class _AudioBtnState extends State<_AudioBtn> {
  bool _playing = false;
  StreamSubscription? _sub;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () async {
          await AudioService.instance.toggle(widget.toque.audio);
          if (mounted) {
            setState(() => _playing = AudioService.instance.isPlaying(widget.toque.audio));
          }
        },
        icon: Icon(_playing ? Icons.stop : Icons.play_arrow),
        label: Text(_playing ? 'Reproduzindo...' : 'Ouvir Toque'),
      ),
    );
  }
}

Future<void> _vibrar(AppProvider p, List<int> pattern) async {
  if (!p.haptico) return;
  final hasVibrator = await Vibration.hasVibrator();
  if (hasVibrator == true) Vibration.vibrate(pattern: pattern);
}

void _feedbackAcerto(AppProvider p) {
  if (p.som) HapticFeedback.lightImpact();
  _vibrar(p, [0, 40]);
}

void _feedbackErro(AppProvider p) {
  if (p.som) HapticFeedback.heavyImpact();
  _vibrar(p, [0, 80, 50, 80]);
}

// ── Conquista overlay ─────────────────────────────────────────────────────────

void _mostrarConquista(BuildContext context, String nomeToque) {
  final ctrl = ConfettiController(duration: const Duration(seconds: 3));
  ctrl.play();
  Timer? autoClose;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (dialogCtx) {
      autoClose = Timer(const Duration(seconds: 3), () {
        if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
      });
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          ConfettiWidget(
            confettiController: ctrl,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 30,
            colors: const [
              Color(0xFF3B5BFF), Color(0xFF2ECC71),
              Color(0xFFF5C542), Color(0xFFFF6B35),
            ],
          ),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(dialogCtx).pop(),
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events, color: Color(0xFFF5A623), size: 56),
                    const SizedBox(height: 12),
                    const Text('Dominado!',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: Color(0xFF111111))),
                    const SizedBox(height: 6),
                    Text('$nomeToque está dominado',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, color: Color(0xFF555555))),
                    const SizedBox(height: 12),
                    const Text('Toque para continuar',
                        style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA))),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  ).then((_) {
    autoClose?.cancel();
    ctrl.dispose();
  });
}

// ── Modo Clássico ─────────────────────────────────────────────────────────────

class _QuestaoClassicaScreen extends StatefulWidget {
  const _QuestaoClassicaScreen();

  @override
  State<_QuestaoClassicaScreen> createState() => _QuestaoClassicaScreenState();
}

class _QuestaoClassicaScreenState extends State<_QuestaoClassicaScreen> {
  bool _mostrouResposta = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.provaFinalizada) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.salvarEEncerrarProva();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ResultadoScreen()));
      });
      return const SizedBox.shrink();
    }

    final toque = provider.toqueAtual!;
    final ac = context.ac;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Clássico'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmarSaida(context, provider),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProgressoTopo(provider.indice, provider.prova.length),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Text(
                        'Toque ${provider.indice + 1} de ${provider.prova.length}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18, color: ac.text1),
                      ),
                      const SizedBox(height: 20),
                      _AudioBtn(toque),
                      if (!_mostrouResposta) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ac.border, foregroundColor: ac.text1),
                            onPressed: () => setState(() => _mostrouResposta = true),
                            child: const Text('Mostrar Resposta'),
                          ),
                        ),
                      ],
                      if (_mostrouResposta) ...[
                        const SizedBox(height: 20),
                        Text(toque.nome,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: ac.text1)),
                        if (toque.bizu.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ac.accentBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('"${toque.bizu}"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ac.accent, fontStyle: FontStyle.italic)),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text('Você acertou?', style: TextStyle(color: ac.text2)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF27AE60)),
                                onPressed: () => _responder(true),
                                icon: const Icon(Icons.check),
                                label: const Text('Acertei'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE74C3C)),
                                onPressed: () => _responder(false),
                                icon: const Icon(Icons.close),
                                label: const Text('Errei'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _responder(bool acertou) async {
    final provider = context.read<AppProvider>();
    final toque = provider.toqueAtual!;
    await AudioService.instance.stop();
    if (acertou) { _feedbackAcerto(provider); } else { _feedbackErro(provider); }
    final recemDominado = provider.responder(acertou);
    if (recemDominado && mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) _mostrarConquista(context, toque.nome);
    }
    setState(() => _mostrouResposta = false);
  }
}

// ── Múltipla Escolha ──────────────────────────────────────────────────────────

class _QuestaoMCScreen extends StatefulWidget {
  const _QuestaoMCScreen();

  @override
  State<_QuestaoMCScreen> createState() => _QuestaoMCScreenState();
}

class _QuestaoMCScreenState extends State<_QuestaoMCScreen> {
  late List<Toque> _opcoes;
  int? _selecionado;
  bool _respondeu = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gerarOpcoes();
  }

  void _gerarOpcoes() {
    final provider = context.read<AppProvider>();
    if (!provider.provaAtiva) return;
    final correto = provider.toqueAtual!;
    final erradas = (List<Toque>.from(toques)..shuffle())
        .where((t) => t.id != correto.id)
        .take(3)
        .toList();
    _opcoes = ([correto, ...erradas])..shuffle();
    _selecionado = null;
    _respondeu = false;
  }

  _EstadoOpcao _estadoOpcao(Toque op, Toque correto) {
    if (!_respondeu) return _EstadoOpcao.normal;
    if (op.id == correto.id) return _EstadoOpcao.correta;
    if (op.id == _opcoes[_selecionado!].id) return _EstadoOpcao.errada;
    return _EstadoOpcao.normal;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.provaFinalizada) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.salvarEEncerrarProva();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ResultadoScreen()));
      });
      return const SizedBox.shrink();
    }

    final toque = provider.toqueAtual!;
    final ac = context.ac;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Múltipla Escolha'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmarSaida(context, provider),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProgressoTopo(provider.indice, provider.prova.length),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Questão ${provider.indice + 1} de ${provider.prova.length}',
                          style: TextStyle(color: ac.text2, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Qual é este toque?',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: ac.text1)),
                      const SizedBox(height: 16),
                      _AudioBtn(toque),
                      const SizedBox(height: 20),
                      ..._opcoes.map((op) => _OpcaoBtn(
                            label: op.nome,
                            estado: _estadoOpcao(op, toque),
                            habilitado: !_respondeu,
                            onTap: () => _responder(op.id == toque.id, _opcoes.indexOf(op)),
                          )),
                      if (_respondeu &&
                          _opcoes[_selecionado!].id != toque.id &&
                          toque.bizu.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9C4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  color: Color(0xFFF5A623), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: '${toque.nome}: ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87)),
                                  TextSpan(
                                      text: '"${toque.bizu}"',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black87)),
                                ])),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _responder(bool acertou, int idx) async {
    if (_respondeu) return;
    final provider = context.read<AppProvider>();
    final toque = provider.toqueAtual!;
    await AudioService.instance.stop();
    setState(() { _selecionado = idx; _respondeu = true; });
    if (acertou) { _feedbackAcerto(provider); } else { _feedbackErro(provider); }
    final recemDominado = provider.responder(acertou);
    await Future.delayed(Duration(milliseconds: acertou ? 1300 : 2100));
    if (!mounted) return;
    if (recemDominado) {
      _mostrarConquista(context, toque.nome);
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
    }
    _gerarOpcoes();
    setState(() {});
  }
}

enum _EstadoOpcao { normal, correta, errada }

class _OpcaoBtn extends StatelessWidget {
  final String label;
  final _EstadoOpcao estado;
  final bool habilitado;
  final VoidCallback onTap;
  const _OpcaoBtn({
    required this.label,
    required this.estado,
    required this.habilitado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final (Color bg, Color border, Color fg) = switch (estado) {
      _EstadoOpcao.correta => (
          const Color(0xFF27AE60).withValues(alpha: 0.1),
          const Color(0xFF27AE60),
          const Color(0xFF27AE60),
        ),
      _EstadoOpcao.errada => (
          const Color(0xFFE74C3C).withValues(alpha: 0.1),
          const Color(0xFFE74C3C),
          const Color(0xFFE74C3C),
        ),
      _EstadoOpcao.normal => (Colors.transparent, ac.border, ac.text1),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15, color: fg))),
              if (estado == _EstadoOpcao.correta)
                Icon(Icons.check_circle, color: border, size: 20),
              if (estado == _EstadoOpcao.errada)
                Icon(Icons.cancel, color: border, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Resultado ─────────────────────────────────────────────────────────────────

class ResultadoScreen extends StatelessWidget {
  const ResultadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final historico = provider.historico;
    final erros = provider.erros;
    final ultimo = historico.isNotEmpty ? historico.last : null;
    final acertos = ultimo?.acertos ?? 0;
    final total = ultimo?.total ?? 1;
    final pct = ultimo?.percentual ?? 0;
    final ac = context.ac;

    final (Color placarColor, IconData placarIcon) = pct >= 80
        ? (const Color(0xFF27AE60), Icons.check_circle)
        : pct >= 50
            ? (const Color(0xFFF5A623), Icons.warning_amber)
            : (const Color(0xFFE74C3C), Icons.cancel);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado Final')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Icon(placarIcon, color: placarColor, size: 56),
                const SizedBox(height: 8),
                Text('$acertos/$total',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 36, color: placarColor)),
                Text('$pct% de aproveitamento',
                    style: TextStyle(color: ac.text2, fontSize: 14)),
                const SizedBox(height: 20),
                if (erros.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C)),
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const _RevisaoErrosScreen())),
                      icon: const Icon(Icons.replay),
                      label: Text('Praticar ${erros.length} erro(s)'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SimuladoScreen()),
                      (r) => r.isFirst,
                    ),
                    child: const Text('Novo Simulado'),
                  ),
                ),
                if (historico.length > 1) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Histórico Recente',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15, color: ac.text1)),
                  ),
                  const SizedBox(height: 8),
                  ...historico.reversed.skip(1).take(4).map((h) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(h.data, style: TextStyle(color: ac.text2, fontSize: 13)),
                            Text('${h.acertos}/${h.total} (${h.percentual}%)',
                                style: TextStyle(
                                    color: ac.text1,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Revisão de Erros ──────────────────────────────────────────────────────────

class _RevisaoErrosScreen extends StatelessWidget {
  const _RevisaoErrosScreen();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final lista = provider.erros;
    final ac = context.ac;

    return Scaffold(
      appBar: AppBar(title: const Text('Revisão de Erros')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Revisão de Erros',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20, color: ac.text1)),
                const SizedBox(height: 4),
                Text('${lista.length} toque(s) para praticar — ouça antes de começar',
                    style: TextStyle(color: ac.text2, fontSize: 13)),
                const SizedBox(height: 16),
                ...lista.map((t) => _ErroItem(t)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      provider.iniciarProvaComErros();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const QuestaoScreen()));
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Iniciar Quiz'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SimuladoScreen()),
                      (r) => r.isFirst,
                    ),
                    child: const Text('Voltar ao início'),
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

class _ErroItem extends StatefulWidget {
  final Toque toque;
  const _ErroItem(this.toque);

  @override
  State<_ErroItem> createState() => _ErroItemState();
}

class _ErroItemState extends State<_ErroItem> {
  bool _playing = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = AudioService.instance.stateStream.listen((_) {
      if (mounted) setState(() => _playing = AudioService.instance.isPlaying(widget.toque.audio));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ac.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.toque.nome,
                    style: TextStyle(fontWeight: FontWeight.w600, color: ac.text1)),
                if (widget.toque.bizu.isNotEmpty)
                  Text('"${widget.toque.bizu}"',
                      style: TextStyle(
                          fontSize: 12,
                          color: ac.text2,
                          fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(_playing ? Icons.stop : Icons.play_arrow, color: ac.accent),
            onPressed: () async {
              await AudioService.instance.toggle(widget.toque.audio);
              if (mounted) {
                setState(() => _playing = AudioService.instance.isPlaying(widget.toque.audio));
              }
            },
          ),
        ],
      ),
    );
  }
}

// ── Helper ────────────────────────────────────────────────────────────────────

void _confirmarSaida(BuildContext context, AppProvider provider) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Sair do simulado?'),
      content: const Text('Você perderá o progresso desta sessão.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            AudioService.instance.stop();
            provider.resetarProva();
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
          child: const Text('Sair'),
        ),
      ],
    ),
  );
}
