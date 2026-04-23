# Toques de Corneta — CEFS A 2026 · Pelotão Delta

Aplicativo web progressivo (PWA) para auxiliar os alunos do **CEFS A 2026 – Pelotão Delta** na memorização dos toques de corneta militares. Funciona como um app instalável no celular, com suporte a uso offline.

---

## O que o app faz

O app reúne os 15 toques de corneta regulamentares utilizados nas atividades do pelotão. Para cada toque, o aluno pode ouvir o áudio original e consultar o **bizu** — uma frase mnemônica que ajuda a memorizar o som. Além da lista de referência, o app oferece um simulado interativo para testar o conhecimento antes das provas e atividades.

---

## Funcionalidades

### Lista de Toques
- Exibe todos os 15 toques de corneta em cards individuais
- Cada card mostra o nome do toque e o bizu correspondente
- Botão de reprodução com 3 estados visuais:
  - **Reproduzir** — pronto para tocar
  - **Carregando…** — buscando o arquivo de áudio
  - **Reproduzindo…** — áudio em execução (clicar novamente para parar)
- Ao iniciar um novo toque, o anterior é pausado automaticamente

### Simulado
- Antes de iniciar, o aluno escolhe a quantidade de questões: **5**, **10** ou **todas (15)**
- As questões são sorteadas aleatoriamente com o algoritmo **Fisher-Yates**, garantindo distribuição uniforme
- Fluxo de cada questão:
  1. O aluno ouve o toque sem ver o nome
  2. Clica em **Mostrar Resposta** para revelar o nome e o bizu
  3. Avalia se acertou ou errou (autoavaliação)
- **Barra de progresso** visual no topo indica o avanço dentro do simulado
- Ao final, é exibido o resultado com **código de cor**:
  - Verde — 80% ou mais de acertos
  - Laranja — entre 50% e 79%
  - Vermelho — abaixo de 50%
- Se houver erros, aparece o botão **Revisar erros** para repetir apenas os toques que o aluno não acertou
- O histórico das últimas 5 provas é salvo localmente e exibido ao final de cada simulado

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

### Por que sem framework?

- O app tem escopo bem definido e pequeno — nenhuma abstração adicional agrega valor real
- Zero tempo de build, zero configuração de bundler
- Carrega instantaneamente, mesmo em conexões lentas
- Qualquer pessoa com conhecimento básico de web consegue ler e modificar o código

### Decisões técnicas relevantes

**Fisher-Yates para embaralhamento**
O método `.sort(() => Math.random() - 0.5)` produz distribuição estatisticamente enviesada — algumas questões aparecem com muito mais frequência do que outras. O algoritmo Fisher-Yates percorre o array de trás para frente trocando cada elemento por um índice aleatório dentro do intervalo restante, garantindo que todas as permutações sejam igualmente prováveis.

**Service Worker com cache completo**
Todos os assets estáticos (HTML, CSS, JS, manifest, ícones, imagem do pelotão e os 15 arquivos de áudio) são pré-cacheados na instalação do Service Worker. A estratégia é *cache-first*: o app responde do cache sem fazer nenhuma requisição de rede, o que garante funcionamento offline real e carregamento instantâneo em visitas subsequentes. Quando o cache é atualizado (versão nova), o `activate` remove versões antigas automaticamente.

**Estados visuais do botão de áudio**
O botão passa por três estados distintos gerenciados pela função `setBotao()`:
1. `play` — ocioso, pronto para reproduzir
2. `loader-2` — carregando o arquivo (botão desabilitado)
3. `square` — reproduzindo (botão habilitado; clicar para ou)

A transição de *carregando* para *reproduzindo* ocorre no evento `canplay`, que o browser dispara quando já há dados suficientes para começar a tocar sem interrupção. O evento `ended` restaura o botão ao estado inicial. A variável `botaoAtual` rastreia qual botão está ativo para restaurá-lo caso o usuário inicie outro toque antes do atual terminar.

**localStorage para histórico**
Os resultados dos simulados são persistidos com `localStorage` usando a chave `cefs-historico`. São mantidos no máximo 5 registros — quando o limite é atingido, o mais antigo é removido com `Array.shift()`. Isso evita crescimento indefinido de dados e mantém o histórico relevante e recente.

**Ícones Lucide em vez de emojis**
Emojis têm renderização inconsistente entre sistemas operacionais, fabricantes de dispositivos e versões de SO. O mesmo emoji pode ter cor, proporção e estilo completamente diferentes no iOS, Android e Windows. Os ícones Lucide são SVGs vetoriais com traço uniforme (`stroke-width: 2.5`), tamanho controlado por CSS e aparência idêntica em qualquer plataforma. A biblioteca é carregada via CDN (UMD) e os ícones são inicializados com `lucide.createIcons()` após cada atualização do DOM.

**Lazy loading da imagem do pelotão**
A foto `pelotao.jpg` só é exibida na aba Informações. Com `loading="lazy"` e `decoding="async"`, o browser adia o download até o momento em que o elemento está prestes a entrar na viewport, economizando banda e acelerando o carregamento inicial.

**Carregamento assíncrono da fonte**
A fonte Inter é carregada com `media="print"` e `onload="this.media='all'"`, uma técnica que impede o bloqueio de renderização: o browser não precisa esperar a fonte carregar para exibir o conteúdo. Um `<noscript>` garante o fallback para ambientes sem JavaScript.

---

## Estrutura do projeto

```
toquesdecorneta/
├── index.html          # Estrutura HTML, nav, toast de instalação
├── script.js           # Lógica do app (lista, simulado, áudio, PWA)
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

*Versão 1.2.0 — CEFS A 2026 · Pelotão Delta*
