import 'package:flutter/foundation.dart';
import '../data/metrica.dart';
import '../data/srs.dart';
import '../data/storage.dart';
import '../data/toque.dart';

enum ModoSimulado { classico, multipla }

class AppProvider extends ChangeNotifier {
  final Storage storage;

  AppProvider(this.storage) {
    _metricas  = storage.getMetricas();
    _som       = storage.som;
    _haptico   = storage.haptico;
  }

  // ── TEMA ────────────────────────────────────────────────────────────────────

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  void setDarkMode(bool v) {
    _darkMode = v;
    storage.setTema(v ? 'dark' : 'light');
    notifyListeners();
  }

  void initTheme() {
    final saved = storage.tema;
    _darkMode = saved == 'dark';
  }

  // ── CONFIG ──────────────────────────────────────────────────────────────────

  bool _som     = true;
  bool _haptico = true;
  bool get som     => _som;
  bool get haptico => _haptico;

  void toggleSom() {
    _som = !_som;
    storage.setSom(_som);
    notifyListeners();
  }

  void toggleHaptico() {
    _haptico = !_haptico;
    storage.setHaptico(_haptico);
    notifyListeners();
  }

  // ── MÉTRICAS ────────────────────────────────────────────────────────────────

  Map<int, MetricaToque> _metricas = {};
  Map<int, MetricaToque> get metricas => _metricas;

  MetricaToque getMetrica(int id) =>
      _metricas[id] ?? const MetricaToque();

  /// Returns true if the toque was just mastered.
  bool registrarResposta(int toqueId, bool acertou) {
    final atual = getMetrica(toqueId);
    final (updated, recemDominado) = atualizarMetrica(atual, acertou);
    _metricas = Map.from(_metricas)..[toqueId] = updated;
    storage.salvarMetricas(_metricas);
    notifyListeners();
    return recemDominado;
  }

  // ── QUIZ STATE ──────────────────────────────────────────────────────────────

  List<Toque> _prova = [];
  int _indice = 0;
  int _acertos = 0;
  List<Toque> _erros = [];
  ModoSimulado _modo = ModoSimulado.classico;

  List<Toque> get prova     => _prova;
  int          get indice   => _indice;
  int          get acertos  => _acertos;
  List<Toque>  get erros    => _erros;
  ModoSimulado get modo     => _modo;
  bool         get provaAtiva => _prova.isNotEmpty && _indice < _prova.length;
  Toque?       get toqueAtual => provaAtiva ? _prova[_indice] : null;

  void setModo(ModoSimulado m) {
    _modo = m;
    notifyListeners();
  }

  void iniciarProva(int total) {
    _prova   = selecionarToquesPonderados(toques, _metricas, total);
    _indice  = 0;
    _acertos = 0;
    _erros   = [];
    notifyListeners();
  }

  void iniciarProvaComErros() {
    final lista = List<Toque>.from(_erros)..shuffle();
    _prova   = lista;
    _indice  = 0;
    _acertos = 0;
    _erros   = [];
    notifyListeners();
  }

  /// Returns true if the toque was just mastered.
  bool responder(bool acertou) {
    final toque = toqueAtual!;
    final recemDominado = registrarResposta(toque.id, acertou);
    if (acertou) {
      _acertos++;
    } else {
      _erros.add(toque);
    }
    _indice++;
    notifyListeners();
    return recemDominado;
  }

  bool get provaFinalizada => _prova.isNotEmpty && _indice >= _prova.length;

  void salvarEEncerrarProva() {
    if (_prova.isNotEmpty) {
      storage.adicionarResultado(_acertos, _prova.length);
    }
    _prova  = [];
    _indice = 0;
    notifyListeners();
  }

  void resetarProva() {
    _prova  = [];
    _indice = 0;
    _acertos = 0;
    _erros  = [];
    notifyListeners();
  }

  // ── HISTÓRICO ────────────────────────────────────────────────────────────────

  List<ResultadoHistorico> get historico => storage.getHistorico();
}
