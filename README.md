# Toques de Corneta — CEFS A 2026 · Pelotão Delta

Aplicativo web progressivo (PWA) para auxiliar os alunos do **CEFS A 2026 – Pelotão Delta** na memorização dos toques de corneta militares. Funciona como um app instalável no celular, com suporte a uso offline.

---

## O que o app faz

O app reúne os 15 toques de corneta regulamentares utilizados nas atividades do pelotão. Para cada toque, o aluno pode ouvir o áudio original e consultar o **bizu** — uma frase mnemônica que ajuda a memorizar o som.

Além da lista de referência, o app oferece um sistema de treino progressivo com **repetição espaçada (SRS)**, dois modos de quiz, métricas individuais por toque e revisão direcionada de erros.

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
- **Card de progresso geral** no topo com barra segmentada mostrando a distribuição dos 15 toques entre os três níveis

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

Toques mais fracos e mais esquecidos têm maior probabilidade de ser selecionados para a sessão. Um toque "Aprendendo" não revisado há 8 dias tem peso 5 — cinco vezes mais provável de aparecer do que um "Dominado" revisado hoje. O badge **🎯 Adaptativo** aparece na barra de progresso durante o quiz.

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

### Revisão de Erros

Ao final de qualquer quiz com erros:
1. O botão "Praticar N erro(s)" abre uma **tela dedicada de revisão**
2. A tela lista cada toque errado com nome, bizu e botão de escuta individual
3. O aluno ouve os toques que errou antes de decidir iniciar o quiz de erros
4. "Iniciar Quiz" começa um novo quiz restrito aos toques errados, no mesmo modo

### Histórico de Simulados
- Armazena os últimos 5 resultados com data, acertos e total
- Exibido ao final de cada simulado
- Persiste entre sessões via `localStorage`

### Informações
- Foto do Pelotão Delta
- Descrição do propósito do app
- Aviso de uso educacional
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
A seleção de toques usa um pool ponderado: cada toque é inserido N vezes conforme seu peso (domínio + tempo). O pool é embaralhado com Fisher-Yates e os toques são extraídos em ordem, ignorando duplicatas. Isso garante que todos os toques possam aparecer, mas os mais fracos e mais esquecidos têm muito mais chance de ser selecionados primeiro.

**localStorage para métricas e histórico**
Dois namespaces distintos:
- `cefs-metricas` — objeto indexado por ID do toque, com acertos, erros, sequência, `ultimaVez` (ISO 8601) e domínio calculado
- `cefs-historico` — array com os últimos 5 resultados de simulado

**Fisher-Yates para embaralhamento**
O método `.sort(() => Math.random() - 0.5)` produz distribuição estatisticamente enviesada. Fisher-Yates percorre o array de trás para frente trocando cada elemento por um índice aleatório dentro do intervalo restante, garantindo que todas as permutações sejam igualmente prováveis.

**Service Worker com cache completo**
Todos os assets estáticos (HTML, CSS, JS, manifest, ícones, imagem e 15 arquivos de áudio) são pré-cacheados na instalação. A estratégia é *cache-first*: o app responde do cache sem fazer requisição de rede. Quando uma versão nova é publicada, o `activate` remove versões antigas automaticamente.

**Delay adaptativo no modo MC**
Acerto avança em 1,3 s. Erro aguarda 2,1 s para que o aluno tenha tempo de ler o bizu exibido no hint amarelo antes de ir para a próxima questão.

**Ícones Lucide em vez de emojis**
Emojis têm renderização inconsistente entre sistemas operacionais. Os ícones Lucide são SVGs vetoriais com traço uniforme, tamanho controlado por CSS e aparência idêntica em qualquer plataforma.

**Lazy loading da imagem do pelotão**
`loading="lazy"` e `decoding="async"` adiam o download da foto até o momento em que ela está prestes a entrar na viewport, economizando banda e acelerando o carregamento inicial.

---

## Estrutura do projeto

```
toquesdecorneta/
├── index.html          # Estrutura HTML, nav, toast de instalação
├── script.js           # Lógica do app (lista, métricas, SRS, quiz, áudio, PWA)
├── style.css           # Estilos e layout
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

*Versão 1.6.0 — CEFS A 2026 · Pelotão Delta*
