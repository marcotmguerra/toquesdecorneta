# Checklist de Lançamento — Toques de Corneta

> Versão atual: 2.7.3+1  
> Atualizado em: 30/04/2026

---

## Crítico — sem isso a Play Store rejeita ou o app fica ruim

### 1. Configurar assinatura de release Android

**Arquivo:** `android/app/build.gradle.kts` (linha 37)

**Problema:** o release build ainda assina com a debug key. A Play Store rejeita APKs assinados com debug key.

**Como resolver:**

```bash
# 1. Gerar o keystore (rodar uma vez, guardar o arquivo .jks com segurança)
keytool -genkey -v \
  -keystore ~/toques-release.jks \
  -alias toques \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# 2. Criar o arquivo android/key.properties (NÃO commitar esse arquivo)
storePassword=SUA_SENHA
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=toques
storeFile=/caminho/absoluto/para/toques-release.jks
```

Em `android/app/build.gradle.kts`, substituir o bloco `android { ... }` para incluir:

```kotlin
// Ler o key.properties
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(keyPropertiesFile.inputStream())
}

android {
    // ... resto das configs ...

    signingConfigs {
        create("release") {
            keyAlias = keyProperties["keyAlias"] as String
            keyPassword = keyProperties["keyPassword"] as String
            storeFile = file(keyProperties["storeFile"] as String)
            storePassword = keyProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

Adicionar ao `.gitignore`:
```
android/key.properties
*.jks
*.keystore
```

> **Importante:** guarde o arquivo `.jks` e as senhas em local seguro. Se perder, não consegue mais publicar atualizações no mesmo app.

---

### 2. Substituir o ícone do app

**Problema:** o ícone padrão azul do Flutter ainda está em uso no Android e no iOS.

**Como resolver:**

```bash
# 1. Adicionar a dependência ao pubspec.yaml (em dev_dependencies)
flutter_launcher_icons: ^0.14.1

# 2. Rodar
flutter pub get
```

Adicionar ao final do `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"   # PNG quadrado, mínimo 1024x1024px
  adaptive_icon_background: "#121214"    # Cor de fundo para Android adaptive icon
  adaptive_icon_foreground: "assets/images/icon_foreground.png"
```

```bash
# 3. Gerar os ícones
dart run flutter_launcher_icons
```

---

### 3. Corrigir o nome do app no Android

**Arquivo:** `android/app/src/main/AndroidManifest.xml` (linha 3)

**Problema:** o label está como `toques_de_corneta` — aparece assim na tela inicial do usuário.

**Como resolver:** alterar a linha 3:

```xml
<!-- De: -->
android:label="toques_de_corneta"

<!-- Para: -->
android:label="Toques de Corneta"
```

---

### 4. Forçar orientação retrato

**Arquivo:** `lib/main.dart`

**Problema:** o app não está bloqueado em retrato. Em landscape a UI quebra pois foi projetada para retrato.

**Como resolver:** adicionar em `main()` antes do `runApp`:

```dart
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final storage = await Storage.init();
  runApp(MyApp(storage: storage));
}
```

No iOS, remover landscape do `ios/Runner/Info.plist`:

```xml
<!-- Apagar estas duas linhas de UISupportedInterfaceOrientations: -->
<string>UIInterfaceOrientationLandscapeLeft</string>
<string>UIInterfaceOrientationLandscapeRight</string>
```

---

## Alta prioridade — afeta a experiência do usuário

### 5. Corrigir a fonte Inter

**Arquivo:** `lib/theme.dart` (linhas 16 e 44)

**Problema:** `fontFamily: 'Inter'` está declarado mas não há arquivo `.ttf` em `assets/fonts/`. O sistema usa uma fonte de fallback e o visual fica diferente do esperado.

**Opção A — usar Google Fonts (mais simples):**

```bash
# Adicionar ao pubspec.yaml em dependencies:
google_fonts: ^6.2.1
```

Em `lib/theme.dart`, substituir `fontFamily: 'Inter'` por:

```dart
import 'package:google_fonts/google_fonts.dart';

// Dentro de lightTheme() e darkTheme(), trocar fontFamily por:
textTheme: GoogleFonts.interTextTheme(_textTheme(...)),
// e remover a linha fontFamily: 'Inter'
```

**Opção B — empacotar a fonte localmente:**

```
1. Baixar Inter em https://fonts.google.com/specimen/Inter
2. Colocar os arquivos em assets/fonts/
3. Declarar no pubspec.yaml:
```

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

---

### 6. Remover arquivo estranho dos assets

**Arquivo:** `assets/audios/Teste.gtml`

**Problema:** arquivo não referenciado no código, provavelmente foi commitado por engano. Aumenta o tamanho do APK desnecessariamente.

**Como resolver:**

```bash
rm flutter_app/assets/audios/Teste.gtml
git rm flutter_app/assets/audios/Teste.gtml
```

---

### 7. Corrigir cores hardcoded

**Problema:** três locais usam cores fixas que não respeitam o dark mode.

**Arquivo:** `lib/screens/simulado/questao_screen.dart`
- Overlay de conquista usa `Colors.white` como fundo — some no dark mode
- Dica do bizu em múltipla escolha usa amarelo claro fixo

**Arquivo:** `lib/screens/info_screen.dart`
- Aviso de estudo usa cor amarela hardcoded

**Como resolver:** substituir as cores fixas por valores do tema:

```dart
// Em vez de:
color: Colors.white
color: const Color(0xFFFFF9C4)

// Usar:
color: context.ac.surface
color: context.ac.accentBg
```

---

## Testes mínimos antes de publicar

### 8. Testar em dispositivo físico

O `test/widget_test.dart` atual é um placeholder vazio. Antes de publicar, testar manualmente:

**Fluxo do quiz:**
- [ ] Iniciar quiz clássico com 5, 10 e 27 questões
- [ ] Iniciar quiz múltipla escolha com 5, 10 e 27 questões
- [ ] Todos os 27 áudios tocam sem erro
- [ ] Botão play/pause funciona na lista de toques
- [ ] Resultado final aparece com confete ao acertar tudo
- [ ] Revisão de erros mostra as questões corretas

**Persistência:**
- [ ] Fechar o app no meio de um quiz e reabrir — guard de saída aparece
- [ ] Responder algumas questões, fechar o app, reabrir — métricas mantidas
- [ ] Badges de domínio (Aprendendo / Bom / Dominado) atualizam corretamente

**Visual:**
- [ ] Testar todas as telas em dark mode
- [ ] Testar todas as telas em light mode
- [ ] Onboarding exibe corretamente na primeira abertura
- [ ] Tela de informações mostra a imagem do pelotão

**Dispositivos recomendados para testar:**
- Android com versão antiga (Android 8 ou 9) — valida compatibilidade
- Android com versão recente (Android 13+) — valida comportamento atual

---

## Como gerar o APK/AAB de release

```bash
cd flutter_app

# AAB para Play Store (formato obrigatório)
flutter build appbundle --release

# APK para teste direto no dispositivo
flutter build apk --release

# Saída:
# build/app/outputs/bundle/release/app-release.aab
# build/app/outputs/flutter-apk/app-release.apk
```

---

## Versão e build number

Antes de publicar, atualizar em `pubspec.yaml`:

```yaml
version: 1.0.0+1
#         ^   ^ build number (incrementar a cada upload na Play Store)
#         versão exibida ao usuário
```

---

## Resumo do status

| Item | Status | O que foi feito |
|---|---|---|
| Assinatura de release Android | ✅ Pronto (falta criar key.properties) | `build.gradle.kts` reescrito para ler `key.properties` e assinar com chave release; fallback automático para debug enquanto o arquivo não existir |
| Ícone do app | ⚠️ Configurado (falta adicionar icon.png) | `flutter_launcher_icons ^0.14.1` adicionado ao `pubspec.yaml`; config pronta — só precisa de `assets/images/icon.png` (1024×1024px) e rodar `dart run flutter_launcher_icons` |
| Nome do app no Android | ✅ Pronto | `android:label` corrigido de `toques_de_corneta` para `Toques de Corneta` em `AndroidManifest.xml` |
| Orientação retrato forçada | ✅ Pronto | `SystemChrome.setPreferredOrientations` adicionado em `main.dart`; landscape removido do `Info.plist` (iPhone e iPad) |
| Fonte Inter configurada | ✅ Pronto | `google_fonts ^6.2.1` adicionado; `theme.dart` atualizado para `GoogleFonts.inter().fontFamily` nos temas light e dark |
| Arquivo Teste.gtml removido | ✅ Pronto | Arquivo removido do disco e do git via `git rm` |
| Cores hardcoded corrigidas | ✅ Pronto | Já estava resolvido em commits anteriores — overlay usa `ac.surface`, bizu hint e aviso de estudo fazem `isDark` check |
| Testes em dispositivo físico | ❌ Pendente | Ver checklist de testes manuais abaixo |
| Código e lógica | ✅ Pronto | — |
| Algoritmo SRS | ✅ Pronto | — |
| 27 áudios | ✅ Pronto | — |
| Dark mode | ✅ Pronto | — |
| Persistência de métricas | ✅ Pronto | — |
