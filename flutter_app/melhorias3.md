# Melhorias 3 — Flutter UI/UX

## Lista

- [x] 1. Dark mode: conquista overlay usa `Colors.white` hardcoded → adaptar ao tema
- [x] 2. Dark mode: card de aviso em InfoScreen usa amarelo hardcoded → adaptar ao tema
- [x] 3. Dark mode: dica do bizu (MC) usa amarelo hardcoded → adaptar ao tema
- [x] 4. Material 3: substituir `BottomNavigationBar` por `NavigationBar`
- [x] 5. Navegação: "Novo Simulado" e "Voltar ao início" empilham rota extra → `popUntil`
- [x] 6. UX: título "Revisão de Erros" duplicado (AppBar + dentro do card)
- [x] 7. UX: Onboarding com `PageView` — suporte a swipe entre slides

---

## Detalhes

### 1. Dark mode: conquista overlay
**Onde:** `questao_screen.dart` → `_mostrarConquista()`
**Problema:** container com `color: Colors.white`, textos com `Color(0xFF111111)`,
`Color(0xFF555555)`, `Color(0xFFAAAAAA)` — hardcoded, broken no dark mode.
**Fix:** capturar `ac` antes de abrir o dialog e usar `ac.surface`, `ac.text1`, `ac.text2`, `ac.text3`.

### 2. Dark mode: card de aviso (InfoScreen)
**Onde:** `info_screen.dart` → bloco "Aviso de Estudo"
**Problema:** `Color(0xFFFFF3CD)` bg, `Color(0xFFFFD700)` border, `Colors.black87` texto — hardcoded.
**Fix:** usar `context.isDark` para selecionar cores escuras equivalentes.

### 3. Dark mode: dica do bizu (modo MC)
**Onde:** `questao_screen.dart` → `_QuestaoMCScreen.build()`, bloco do bizu após erro
**Problema:** `Color(0xFFFFF9C4)` bg, `Colors.black87` texto — hardcoded.
**Fix:** usar `context.isDark` para selecionar cores escuras equivalentes.

### 4. Material 3: NavigationBar
**Onde:** `home_screen.dart` + `theme.dart`
**Problema:** `BottomNavigationBar` é componente Material 2; app usa `useMaterial3: true`.
`NavigationBar` M3 tem pill indicator animado na aba selecionada e visual correto.
**Fix:** substituir `BottomNavigationBar`/`BottomNavigationBarItem` por `NavigationBar`/
`NavigationDestination`; atualizar tema para `navigationBarTheme`.

### 5. Navegação: Resultado → voltar ao início
**Onde:** `questao_screen.dart` → `ResultadoScreen` e `_RevisaoErrosScreen`
**Problema:** `pushAndRemoveUntil(SimuladoScreen, isFirst)` empilha `SimuladoScreen` como
rota sem Scaffold sobre `HomeScreen`. O usuário fica preso sem bottom nav.
**Fix:** `Navigator.of(context).popUntil((r) => r.isFirst)` — retorna ao `HomeScreen` com
a aba Simulado já ativa (era a aba em uso quando o quiz foi iniciado).

### 6. UX: título duplicado em Revisão de Erros
**Onde:** `questao_screen.dart` → `_RevisaoErrosScreen`
**Problema:** `AppBar(title: Text('Revisão de Erros'))` + `Text('Revisão de Erros')` dentro
do card — mesma informação em dois lugares.
**Fix:** remover o `Text` redundante dentro do card.

### 7. UX: Onboarding com PageView
**Onde:** `onboarding_screen.dart`
**Problema:** só há botão "Próximo" para avançar slides — sem suporte a swipe, comportamento
esperado em qualquer onboarding mobile.
**Fix:** envolver conteúdo em `PageView.builder` com `PageController`; dots e botão
permanecem fora do PageView (persistentes); `onPageChanged` sincroniza `_page`.
