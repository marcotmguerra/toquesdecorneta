import 'dart:convert';

enum Dominio { aprendendo, bom, dominado }

extension DominioExt on Dominio {
  String get label {
    switch (this) {
      case Dominio.aprendendo: return 'Aprendendo';
      case Dominio.bom:        return 'Bom';
      case Dominio.dominado:   return 'Dominado';
    }
  }
}

class MetricaToque {
  final int acertos;
  final int erros;
  final int sequencia;
  final DateTime? ultimaVez;
  final Dominio dominio;

  const MetricaToque({
    this.acertos = 0,
    this.erros = 0,
    this.sequencia = 0,
    this.ultimaVez,
    this.dominio = Dominio.aprendendo,
  });

  MetricaToque copyWith({
    int? acertos,
    int? erros,
    int? sequencia,
    DateTime? ultimaVez,
    Dominio? dominio,
  }) {
    return MetricaToque(
      acertos:   acertos   ?? this.acertos,
      erros:     erros     ?? this.erros,
      sequencia: sequencia ?? this.sequencia,
      ultimaVez: ultimaVez ?? this.ultimaVez,
      dominio:   dominio   ?? this.dominio,
    );
  }

  Map<String, dynamic> toJson() => {
    'acertos':   acertos,
    'erros':     erros,
    'sequencia': sequencia,
    'ultimaVez': ultimaVez?.toIso8601String(),
    'dominio':   dominio.name,
  };

  factory MetricaToque.fromJson(Map<String, dynamic> j) => MetricaToque(
    acertos:   (j['acertos']   as int?) ?? 0,
    erros:     (j['erros']     as int?) ?? 0,
    sequencia: (j['sequencia'] as int?) ?? 0,
    ultimaVez: j['ultimaVez'] != null ? DateTime.parse(j['ultimaVez'] as String) : null,
    dominio: Dominio.values.firstWhere(
      (d) => d.name == (j['dominio'] as String?),
      orElse: () => Dominio.aprendendo,
    ),
  );
}

class ResultadoHistorico {
  final String data;
  final int acertos;
  final int total;

  const ResultadoHistorico({
    required this.data,
    required this.acertos,
    required this.total,
  });

  int get percentual => total > 0 ? ((acertos / total) * 100).round() : 0;

  Map<String, dynamic> toJson() => {
    'data':    data,
    'acertos': acertos,
    'total':   total,
  };

  factory ResultadoHistorico.fromJson(Map<String, dynamic> j) => ResultadoHistorico(
    data:    j['data']    as String,
    acertos: j['acertos'] as int,
    total:   j['total']   as int,
  );

  static List<ResultadoHistorico> listFromJson(String raw) {
    final list = json.decode(raw) as List<dynamic>;
    return list.map((e) => ResultadoHistorico.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<ResultadoHistorico> list) =>
      json.encode(list.map((e) => e.toJson()).toList());
}
