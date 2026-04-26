# Toques de Corneta — CEFS A 2026 · Pelotão Delta

Aplicativo web progressivo (PWA) para auxiliar os alunos do **CEFS A 2026 – Pelotão Delta** na memorização dos toques de corneta militares. Funciona como app instalável no celular, com suporte a uso offline.

---

## O que o app faz

O app reúne os 15 toques de corneta regulamentares utilizados nas atividades do pelotão. Para cada toque, o aluno pode ouvir o áudio original e consultar o **bizu** — uma frase mnemônica que ajuda a memorizar o som.

Além da lista de referência, o app oferece um sistema completo de treino progressivo com **repetição espaçada (SRS)**, dois modos de quiz, métricas individuais por toque, revisão direcionada de erros, feedback háptico e sonoro, animações de conquista, onboarding interativo e tema claro/escuro.

---

## Funcionalidades

### Lista de Toques
- Exibe todos os 15 toques em cards individuais com nome e bizu
- Botão de reprodução com 3 estados visuais: Reproduzir → Carregando → Reproduzindo
- Ao iniciar um novo toque, o anterior é pausado automaticamente
- Cada card exibe as **métricas do aluno** para aquele toque:
  - Badge de nível de domínio (Aprendendo / Bom / Dominado)
  - Taxa de acerto em porcentagem
  - Sequência de acertos consecutivos (🔥 N seguidos)
  - Tempo desde a última revisão ("hoje", "ontem", "há N dias")
- **Card de progresso geral** no topo com barra segmentada e percentual dominado

### Treino — Modos de Quiz

Antes de iniciar, o aluno escolhe o **modo** e depois a **quantidade de questões** (5, 10 ou todas).

**Modo Clássico**
1. O aluno ouve o toque sem ver o nome
2. Clica em "Mostrar Resposta" para revelar nome e bizu
3. Autoavalia se acertou ou errou

**Modo Múltipla Escolha**
1. O aluno ouve o toque
2. Escolhe entre 4 alternativas embaralhadas
3. Feedback imediato: verde para acerto, vermelho para erro
4. Em caso de erro, a alternativa correta é destacada e o **bizu aparece em destaque** para reforço
5. Avança automaticamente (1,3 s no acerto · 2,1 s no erro para leitura do bizu)

### Dificuldade Adaptativa (SRS)

Em ambos os modos, a seleção de toques não é aleatória — usa **repetição espaçada** com dois fatores:

| Fator | Detalhe |
|---|---|
| Nível de domínio | Aprendendo → peso 3 · Bom → peso 2 · Dominado → peso 1 |
| Tempo desde a última revisão | Não visto há > 7 dias → +2 · > 3 dias → +1 · Revisado hoje → −1 |

Toques mais fracos e mais esquecidos têm maior probabilidade de ser selecionados para a sessão. O badge **🎯 Adaptativo** aparece na barra de progresso durante o quiz.

### Métricas por Toque

Cada toque possui um registro salvo localmente com:
- Total de acertos e erros
- Sequência atual de acertos consecutivos
- Data e hora da última revisão
- Nível de domínio calculado automaticamente

**Progressão de domínio:**
- **Aprendendo** — sequência de acertos < 3
- **Bom** — sequência entre 3 e 5
- **Dominado** — sequência ≥ 6

Qualquer erro zera a sequência e o nível volta para Aprendendo.

### Animação de Conquista

Quando um toque atinge o nível **Dominado**, o app dispara:
- Confetti canvas com 90 partículas coloridas e física de gravidade
- Card central animado com 🏆, nome do toque e mensagem de parabéns
- Fanfarra: arpejo ascendente de 4 notas via Web Audio API
- Vibração celebratória (`[50-30-50-30-120ms]`)

A animação fecha sozinha em 3 s ou ao tocar na tela.

### Revisão de Erros

Ao final de qualquer quiz com erros:
1. O botão "Praticar N erro(s)" abre uma **tela dedicada de revisão**
2. A tela lista cada toque errado com nome, bizu e botão de escuta individual
3. O aluno ouve os toques que errou antes de decidir iniciar o quiz de erros
4. "Iniciar Quiz" começa um novo quiz restrito aos toques errados, no mesmo modo

### Feedback Háptico e Sonoro

Ao responder uma questão (em ambos os modos):

| Resposta | Som | Vibração |
|---|---|---|
| Acerto | Dois tons ascendentes (C5 → G5) | Pulso curto — 40 ms |
| Erro | Tom descendente (260 → 160 Hz) | Duplo — 80-50-80 ms |
| Dominado | Arpejo de 4 notas (fanfarra) | Celebratório — 50-30-50-30-120 ms |

Os sons são gerados via **Web Audio API** (zero arquivos extras). Ambos podem ser desativados independentemente na aba Informações → Configurações.

### Tema Claro / Escuro

- Botão 🌙 no header ativa o tema escuro; ☀️ volta ao claro
- Na primeira abertura, detecta automaticamente `prefers-color-scheme` do sistema
- Escolha salva em `localStorage` — persiste entre sessões
- Transição suave de 0,3 s ao alternar
- Cobertura completa: cards, navegação, botões, badges, resultado, histórico, configurações, revisão de erros, onboarding e animação de conquista

### Onboarding de 3 Telas

Aparece automaticamente **só na primeira abertura**. Bottom sheet animado com:

| Tela | Conteúdo |
|---|---|
| 🎺 Bem-vindo | O que são os toques e o bizu |
| 🧠 Treino inteligente | Explica SRS com badges Aprendendo → Bom → Dominado |
| 🎯 Dois modos de treino | Clássico vs. Múltipla Escolha |

Disponível a qualquer momento em Informações → "Ver introdução".

### Histórico de Simulados
- Armazena os últimos 5 resultados com data, acertos e total
- Exibido ao final de cada simulado
- Persiste entre sessões via `localStorage`

### Informações
- Foto do Pelotão Delta
- Sobre o app e aviso de uso educacional
- **Configurações:** toggles de Som e Vibração
- Link "Ver introdução" para rever o onboarding
- Link para suporte via WhatsApp

---

## Instalação como app (PWA)

O app pode ser instalado diretamente no celular sem passar por nenhuma loja.

**Android (Chrome):** um banner de instalação aparece automaticamente após alguns segundos de uso. Toque em **Instalar**.

**iPhone (Safari):** toque no botão **Compartilhar** e selecione **Adicionar à Tela de Início**.

Após instalado, o app funciona **totalmente offline** — todos os áudios e imagens são armazenados em cache pelo Service Worker na primeira visita.

---

## Toques disponíveis

| # | Nome | Bizu |
|---|------|------|
| 1 | Sentido | Aluno só fica em sentido |
| 2 | Descansar | Des-can-sar |
| 3 | Apresentar Arma | Trás, trás, trás sua irmã pra mim! |
| 4 | Direita volver | Ooolha...ali! |
| 5 | Esquerda volver | Olha, olha, olha... ali! |
| 6 | Meia volta volver | Nunca vi mulher solteira... pari |
| 7 | Ombro arma | Faz ombro arma |
| 8 | Descansar arma | Descansar... arma! |
| 9 | Cruzar arma | Cruzar, cruzar, cruzar! |
| 10 | Ordinário marche | — |
| 11 | Cobrir | Soldaaado vamos cobrir! |
| 12 | Firme | Ai meu Deus que dor! |
| 13 | Alto | Faz alto! |
| 14 | Olhar a direita | — |
| 15 | Olhar frente | Em frente vamos olhar! |

---

## Tecnologia

O app é construído com **HTML, CSS e JavaScript puros**, sem dependências de frameworks. Essa escolha mantém o projeto leve, rápido e fácil de manter.

### Decisões técnicas relevantes

**SRS com pesos combinados**
A seleção de toques usa um pool ponderado: cada toque é inserido N vezes conforme seu peso (domínio + tempo). O pool é embaralhado com Fisher-Yates e os toques são extraídos em ordem, ignorando duplicatas.

**Web Audio API para sons**
Sons de feedback gerados programaticamente — sem arquivos de áudio extras. Osciladores com envelopes de amplitude (`gain.gain.exponentialRampToValueAtTime`) produzem sons limpos e responsivos. Um único `AudioContext` é criado na primeira interação e reutilizado em todas as chamadas subsequentes.

**CSS custom properties para tema**
Variáveis (`--bg`, `--surface`, `--text-1/2/3`, `--border`, `--accent`, etc.) definidas em `:root` para o tema claro e sobrescritas em `[data-theme="dark"]`. Permite alternar o tema inteiro com um único `setAttribute` no `<html>`, sem re-renderizar nada.

**localStorage — três namespaces**
- `cefs-metricas` — objeto por ID do toque: acertos, erros, sequência, `ultimaVez` (ISO 8601), domínio
- `cefs-historico` — últimos 5 resultados de simulado
- `cefs-config` — preferências de som e vibração (`{som: true, haptico: true}`)
- `cefs-tema` — preferência de tema (`"light"` | `"dark"`)
- `cefs-onboarding` — flag de conclusão do onboarding

**Confetti sem biblioteca**
Canvas 2D com 90 partículas, cada uma com posição, velocidade, ângulo e cor aleatórios. A cada frame, `vy += 0.06` simula gravidade. `requestAnimationFrame` mantém a animação suave; `cancelAnimationFrame` para após 2,8 s para não consumir CPU desnecessariamente.

**Fisher-Yates para embaralhamento**
Garante distribuição uniforme — `sort(() => Math.random() - 0.5)` produz distribuição estatisticamente enviesada.

**Service Worker com cache completo**
Estratégia *cache-first*. Todos os assets são pré-cacheados na instalação. O `activate` remove versões antigas automaticamente quando a versão do cache é incrementada.

---

## Estrutura do projeto

```
toquesdecorneta/
├── index.html          # Estrutura HTML, header com toggle de tema, nav, toast
├── script.js           # Lógica completa: lista, SRS, quiz, métricas, feedback,
│                       #   conquista, onboarding, tema, áudio, PWA
├── style.css           # Estilos com CSS custom properties + bloco dark mode
├── sw.js               # Service Worker (cache offline)
├── manifest.json       # Configuração PWA (ícones, cores, modo standalone)
├── pelotao.jpg         # Foto do Pelotão Delta
├── icon-192.png        # Ícone PWA pequeno
├── icon-512.png        # Ícone PWA grande
└── audios/             # 15 arquivos .aac, um por toque
```

---

## Observações

- Os toques seguem o padrão regulamentar, mas **sempre consulte o instrutor do seu pelotão** em caso de dúvida
- O app é uma ferramenta de estudo — o desempenho no simulado não substitui a prática real
- Suporte e sugestões: [WhatsApp](https://wa.me/5531996338032?text=Olá!%20Tenho%20uma%20dúvida/sugestão%20sobre%20o%20App%20de%20Toques%20de%20Corneta.)

---

*Versão 2.0.0 — CEFS A 2026 · Pelotão Delta*
