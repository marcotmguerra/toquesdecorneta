# Flutter Conversion Progress

## Status: Completo — pronto para gerar APK de produção ✅

---

## O que foi feito

### Infraestrutura
- `pubspec.yaml` — dependências: `audioplayers`, `shared_preferences`, `provider`, `confetti`, `vibration`, `google_fonts`
- Dev deps: `flutter_launcher_icons`, `flutter_native_splash`
- `assets/audios/` — todos os 27 arquivos `.aac` copiados
- `assets/images/` — `pelotao.jpg`, `icon-192.png`, `icon-512.png`
- `assets/sounds/` — `acerto.wav`, `erro.wav`, `conquista.wav` (gerados)

### Camada de dados (`lib/data/`)
- `toque.dart` — modelo `Toque` + lista `toques` (27 itens)
- `metrica.dart` — `MetricaToque`, enum `Dominio`, `ResultadoHistorico` (JSON serialization)
- `storage.dart` — wrapper `SharedPreferences` (config, métricas, histórico, tema, onboarding)
- `srs.dart` — algoritmo SRS completo: peso, domínio, seleção ponderada, tempo relativo

### State management (`lib/providers/app_provider.dart`)
- `AppProvider` (ChangeNotifier): tema, config (som/háptico), métricas, estado completo do quiz

### Tema (`lib/theme.dart`)
- `lightTheme()` / `darkTheme()` com Material 3
- Fonte Inter via `google_fonts` (`GoogleFonts.interTextTheme`)
- `AppColors` ThemeExtension com todas as cores custom
- Extension `ThemeX` em `BuildContext` para acesso via `context.ac`

### Serviços
- `lib/audio_service.dart` — singleton `AudioService`
  - `toggle()` para play/stop do toque (player principal)
  - `playOnce(assetPath)` para sons de feedback curtos (player secundário `_fxPlayer`)

### Widgets compartilhados
- `lib/widgets/app_card.dart`
- `lib/widgets/progresso_card.dart`
- `lib/widgets/toque_card.dart`

### Telas
| Tela | Arquivo |
|------|---------|
| main + providers | `lib/main.dart` |
| Bottom nav + guard de saída | `lib/screens/home_screen.dart` |
| Onboarding 4 slides | `lib/screens/onboarding_screen.dart` |
| Lista de toques + progresso | `lib/screens/lista_screen.dart` |
| Seleção de modo | `lib/screens/simulado/simulado_screen.dart` |
| Seleção de quantidade | `lib/screens/simulado/quantidade_screen.dart` |
| Questão clássica + MC + resultado + revisão | `lib/screens/simulado/questao_screen.dart` |
| Informações + configurações + créditos | `lib/screens/info_screen.dart` |

### Configurações de produção aplicadas
- **Nome do app**: `AndroidManifest.xml` → `android:label="Toques de Corneta"`
- **Orientação**: `main.dart` → `SystemChrome.setPreferredOrientations([portraitUp, portraitDown])`
- **Sons de feedback**: `_feedbackAcerto` / `_feedbackErro` / `_mostrarConquista` chamam `AudioService.instance.playOnce(...)`
- **Ícone**: configurado via `flutter_launcher_icons` no `pubspec.yaml`
- **Splash**: configurado via `flutter_native_splash` no `pubspec.yaml` (azul #3B5BFF + icon-192)

---

## Comandos a rodar após `flutter pub get`

```bash
cd flutter_app

# 1. Buscar dependências
flutter pub get

# 2. Gerar ícones do app (substitui o ícone padrão Flutter)
flutter pub run flutter_launcher_icons

# 3. Gerar splash screen nativa
flutter pub run flutter_native_splash:create

# 4. Build debug
flutter build apk --debug

# 5. Build release (para distribuir)
flutter build apk --release
```

---

## Checklist de testes no dispositivo

- [ ] Reprodução de áudio AAC (todos os 27 toques)
- [ ] Sons de feedback ao acertar/errar (acerto.wav / erro.wav)
- [ ] Som + confete ao dominar um toque (conquista.wav)
- [ ] Modo Clássico: fluxo completo
- [ ] Múltipla Escolha: fluxo completo + hint do bizu
- [ ] Revisão de erros
- [ ] Persistência: fechar e reabrir — métricas mantidas
- [ ] Dark mode toggle
- [ ] Onboarding na primeira abertura
- [ ] Botão voltar Android no meio do quiz (guard de saída)
- [ ] Orientação bloqueada em retrato
- [ ] Ícone customizado na launcher
- [ ] Splash azul com ícone ao abrir

---

## Estrutura de arquivos atual

```
flutter_app/
├── assets/
│   ├── audios/          (27 arquivos .aac)
│   ├── images/
│   │   ├── pelotao.jpg
│   │   ├── icon-192.png
│   │   └── icon-512.png
│   └── sounds/
│       ├── acerto.wav
│       ├── erro.wav
│       └── conquista.wav
├── lib/
│   ├── main.dart
│   ├── theme.dart
│   ├── audio_service.dart
│   ├── data/
│   │   ├── toque.dart
│   │   ├── metrica.dart
│   │   ├── storage.dart
│   │   └── srs.dart
│   ├── providers/
│   │   └── app_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── lista_screen.dart
│   │   ├── info_screen.dart
│   │   ├── onboarding_screen.dart
│   │   └── simulado/
│   │       ├── simulado_screen.dart
│   │       ├── quantidade_screen.dart
│   │       └── questao_screen.dart
│   └── widgets/
│       ├── app_card.dart
│       ├── progresso_card.dart
│       └── toque_card.dart
└── pubspec.yaml
```

## Dependências
```yaml
# Runtime
audioplayers: ^6.1.0
shared_preferences: ^2.3.5
provider: ^6.1.2
confetti: ^0.7.0
vibration: ^2.0.0
google_fonts: ^6.2.1

# Dev (geração de assets)
flutter_launcher_icons: ^0.14.1
flutter_native_splash: ^2.4.1
```
