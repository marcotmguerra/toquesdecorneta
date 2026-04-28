import 'metrica.dart';
import 'toque.dart';

int calcularPeso(MetricaToque? m) {
  if (m == null) return 5;

  const pesoDominio = {Dominio.aprendendo: 3, Dominio.bom: 2, Dominio.dominado: 1};
  var peso = pesoDominio[m.dominio] ?? 3;

  if (m.ultimaVez != null) {
    final dias = DateTime.now().difference(m.ultimaVez!).inHours / 24.0;
    if (dias > 7) {
      peso += 2;
    } else if (dias > 3) {
      peso += 1;
    } else if (dias < 1) {
      peso = (peso - 1).clamp(1, 10);
    }
  }

  return peso;
}

Dominio calcularDominio(int sequencia) {
  if (sequencia >= 6) return Dominio.dominado;
  if (sequencia >= 3) return Dominio.bom;
  return Dominio.aprendendo;
}

// Returns updated metrica. The boolean return value is "newly mastered".
(MetricaToque, bool) atualizarMetrica(MetricaToque m, bool acertou) {
  final dominioAnterior = m.dominio;
  final novaSequencia = acertou ? m.sequencia + 1 : 0;
  final updated = m.copyWith(
    acertos:   acertou ? m.acertos + 1 : m.acertos,
    erros:     acertou ? m.erros : m.erros + 1,
    sequencia: novaSequencia,
    ultimaVez: DateTime.now(),
    dominio:   calcularDominio(novaSequencia),
  );
  final recemDominado = updated.dominio == Dominio.dominado && dominioAnterior != Dominio.dominado;
  return (updated, recemDominado);
}

List<Toque> selecionarToquesPonderados(List<Toque> todos, Map<int, MetricaToque> metricas, int total) {
  final pool = <Toque>[];
  for (final t in todos) {
    final peso = calcularPeso(metricas[t.id]);
    for (var i = 0; i < peso; i++) {
      pool.add(t);
    }
  }

  pool.shuffle();

  final vistos = <int>{};
  final selecionados = <Toque>[];
  for (final t in pool) {
    if (!vistos.contains(t.id)) {
      vistos.add(t.id);
      selecionados.add(t);
      if (selecionados.length == total) break;
    }
  }
  return selecionados;
}

String tempoRelativo(DateTime? dt) {
  if (dt == null) return '';
  final dias = DateTime.now().difference(dt).inDays;
  if (dias == 0) return 'hoje';
  if (dias == 1) return 'ontem';
  return 'há $dias dias';
}
