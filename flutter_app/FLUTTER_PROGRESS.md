# Flutter Conversion Progress

## Status: Base completa — build APK debug ✅ | `flutter analyze` 0 erros ✅

---

## O que foi feito

### Infraestrutura
- `pubspec.yaml` — dependências: `audioplayers`, `shared_preferences`, `provider`, `confetti`, `vibration`
- `assets/audios/` — todos os 27 arquivos `.aac` copiados
- `assets/images/pelotao.jpg` — copiado

### Camada de dados (`lib/data/`)
- `toque.dart` — modelo `Toque` + lista `toques` (27 itens)
- `metrica.dart` — `MetricaToque`, enum `Dominio`, `ResultadoHistorico` (JSON serialization)
- `storage.dart` — wrapper `SharedPreferences` (config, métricas, histórico, tema, onboarding)
- `srs.dart` — algoritmo SRS completo: peso, domínio, seleção ponderada, tempo relativo

### State management (`lib/providers/app_provider.dart`)
- `AppProvider` (ChangeNotifier): tema, config (som/háptico), métricas, estado completo do quiz

### Tema (`lib/theme.dart`)
- `lightTheme()` / `darkTheme()` com Material 3
- `AppColors` ThemeExtension com todas as cores custom
- Extension `ThemeX` em `BuildContext` para acesso via `context.ac`

### Serviços
- `lib/audio_service.dart` — singleton `AudioService` com toggle play/stop e stream de estado

### Widgets compartilhados
- `lib/widgets/app_card.dart` — card reutilizável (substituiu 5 cópias idênticas)
- `lib/widgets/progresso_card.dart` — barra de progresso/domínio (substituiu 2 cópias)
- `lib/widgets/toque_card.dart` — card de toque com badge, métricas e play button

### Telas
| Tela | Arquivo |
|------|---------|
| main + providers | `lib/main.dart` |
| Bottom nav + guard de saída | `lib/screens/home_screen.dart` |
| Onboarding 4 slides | `lib/screens/onboarding_screen.dart` |
| Lista de toques + progresso | `lib/screens/lista_screen.dart` |
| Seleção de modo | `lib/screens/simulado/simulado_screen.dart` |
| Seleção de quantidade (input livre + chips) | `lib/screens/simulado/quantidade_screen.dart` |
| Questão clássica + múltipla escolha + resultado + revisão de erros | `lib/screens/simulado/questao_screen.dart` |
| Informações + configurações + créditos | `lib/screens/info_screen.dart` |

### Qualidade (revisão /simplify aplicada)
- Subscription leak em `ToqueCard` corrigido (`_sub?.cancel()` em `dispose`)
- `ConfettiController` com dispose garantido via `Timer` cancelável
- Ternário 3 níveis extraído para `_estadoOpcao()` no modo MC
- Extension `equals` inútil removida
- `Material` transparente desnecessário removido da overlay de conquista
- `!important` no CSS do projeto web removido (cascata já resolvia)

---

## O que fazer na próxima sessão

### 1. Sons de feedback — ALTA PRIORIDADE
O app web sintetiza 3 tons via Web Audio API. No Flutter, a abordagem mais prática é incluir arquivos de áudio curtos:

```
assets/sounds/acerto.mp3      (~0.3s, dois bipes ascendentes)
assets/sounds/erro.mp3        (~0.3s, tom descendente)
assets/sounds/conquista.mp3   (~0.6s, arpejo de 4 notas)
```

**Como fazer:**
1. Gerar os 3 arquivos (pode usar Audacity, garageband, ou um gerador online de tons)
2. Adicionar `assets/sounds/` ao `pubspec.yaml`
3. Em `questao_screen.dart`, chamar `AudioService.instance.playOnce('sounds/acerto.mp3')` nas funções `_feedbackAcerto` e `_feedbackErro`
4. Adicionar método `playOnce(path)` no `AudioService` (player secundário dedicado para sons curtos, para não interromper o áudio do toque)

### 2. Ícone do app — ALTA PRIORIDADE
Substituir o ícone Flutter padrão pelo ícone do projeto.

```yaml
# pubspec.yaml — adicionar:
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon-512.png"
```

**Como fazer:**
1. Copiar `icon-192.png` e `icon-512.png` para `flutter_app/assets/images/`
2. Adicionar config acima ao `pubspec.yaml`
3. Rodar: `flutter pub run flutter_launcher_icons`

### 3. Fonte Inter — MÉDIA PRIORIDADE
O app web usa Inter (Google Fonts). No Flutter, duas opções:

**Opção A** (recomendada — sem dependência de rede):
1. Baixar Inter em https://fonts.google.com/specimen/Inter
2. Colocar os `.ttf` em `flutter_app/assets/fonts/`
3. Declarar no `pubspec.yaml` na seção `fonts:`

**Opção B** (mais simples):
```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.2.1
```
Em `theme.dart`, trocar `fontFamily: 'Inter'` por `GoogleFonts.interTextTheme(base)`.

### 4. Nome e orientação do app — MÉDIA PRIORIDADE

**Android** — editar `flutter_app/android/app/src/main/AndroidManifest.xml`:
```xml
<application android:label="Toques de Corneta" ...>
```

**Bloquear retrato** — adicionar em `main()` antes de `runApp`:
```dart
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);
```

### 5. Splash screen — MÉDIA PRIORIDADE
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_native_splash: ^2.4.1

flutter_native_splash:
  color: "#3B5BFF"
  image: assets/images/icon-192.png
  android_12:
    color: "#3B5BFF"
    image: assets/images/icon-192.png
```
Rodar: `flutter pub run flutter_native_splash:create`

### 6. Testar no dispositivo — ALTA PRIORIDADE (antes de publicar)
```bash
# Conectar Android com USB debugging
flutter devices
flutter run -d <device-id>
```
Pontos críticos para testar manualmente:
- [ ] Reprodução de áudio AAC (todos os 27 toques)
- [ ] Modo Clássico: fluxo completo (acertar + errar + conquista)
- [ ] Múltipla Escolha: fluxo completo + hint do bizu
- [ ] Revisão de erros
- [ ] Persistência: fechar e reabrir o app — métricas mantidas
- [ ] Dark mode toggle
- [ ] Onboarding na primeira abertura
- [ ] Botão voltar do Android no meio do quiz (guard de saída)

---

## Estrutura de arquivos atual

```
flutter_app/
├── assets/
│   ├── audios/          (27 arquivos .aac)
│   └── images/
│       └── pelotao.jpg
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
audioplayers: ^6.1.0       # Reprodução de áudio AAC
shared_preferences: ^2.3.5  # Persistência local (métricas, config, tema)
provider: ^6.1.2            # State management
confetti: ^0.7.0            # Animação de confete na conquista
vibration: ^2.0.0           # Padrões de vibração háptica
```
