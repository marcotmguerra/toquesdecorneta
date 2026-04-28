import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'metrica.dart';

const _keyConfig    = 'cefs-config';
const _keyMetricas  = 'cefs-metricas';
const _keyHistorico = 'cefs-historico';
const _keyTema      = 'cefs-tema';
const _keyOnboarding = 'cefs-onboarding';

class Storage {
  final SharedPreferences _prefs;
  Storage._(this._prefs);

  static Future<Storage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return Storage._(prefs);
  }

  // ── CONFIG ──────────────────────────────────────────────────────────────────

  bool get som      => _getBool(_keyConfig, 'som',     true);
  bool get haptico  => _getBool(_keyConfig, 'haptico', true);

  Future<void> setSom(bool v)     => _setBool(_keyConfig, 'som',     v);
  Future<void> setHaptico(bool v) => _setBool(_keyConfig, 'haptico', v);

  bool _getBool(String key, String field, bool def) {
    final raw = _prefs.getString(key);
    if (raw == null) return def;
    final map = json.decode(raw) as Map<String, dynamic>;
    return (map[field] as bool?) ?? def;
  }

  Future<void> _setBool(String key, String field, bool value) async {
    final raw = _prefs.getString(key);
    final map = raw != null ? (json.decode(raw) as Map<String, dynamic>) : <String, dynamic>{};
    map[field] = value;
    await _prefs.setString(key, json.encode(map));
  }

  // ── TEMA ────────────────────────────────────────────────────────────────────

  String? get tema => _prefs.getString(_keyTema);
  Future<void> setTema(String v) => _prefs.setString(_keyTema, v);

  // ── ONBOARDING ──────────────────────────────────────────────────────────────

  bool get onboardingConcluido => _prefs.getString(_keyOnboarding) != null;
  Future<void> concluirOnboarding() => _prefs.setString(_keyOnboarding, '1');
  Future<void> resetarOnboarding()  => _prefs.remove(_keyOnboarding);

  // ── MÉTRICAS ────────────────────────────────────────────────────────────────

  Map<int, MetricaToque> getMetricas() {
    final raw = _prefs.getString(_keyMetricas);
    if (raw == null) return {};
    final map = json.decode(raw) as Map<String, dynamic>;
    return map.map((k, v) =>
        MapEntry(int.parse(k), MetricaToque.fromJson(v as Map<String, dynamic>)));
  }

  Future<void> salvarMetricas(Map<int, MetricaToque> metricas) {
    final map = metricas.map((k, v) => MapEntry(k.toString(), v.toJson()));
    return _prefs.setString(_keyMetricas, json.encode(map));
  }

  // ── HISTÓRICO ───────────────────────────────────────────────────────────────

  List<ResultadoHistorico> getHistorico() {
    final raw = _prefs.getString(_keyHistorico);
    if (raw == null) return [];
    return ResultadoHistorico.listFromJson(raw);
  }

  Future<void> adicionarResultado(int acertos, int total) async {
    final historico = getHistorico();
    historico.add(ResultadoHistorico(
      data: _formatDate(DateTime.now()),
      acertos: acertos,
      total: total,
    ));
    final recentes = historico.length > 5
        ? historico.sublist(historico.length - 5)
        : historico;
    await _prefs.setString(_keyHistorico, ResultadoHistorico.listToJson(recentes));
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}
