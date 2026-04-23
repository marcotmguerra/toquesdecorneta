# Sugestões de Melhoria — Toques de Corneta CEFS

> Análise técnica do projeto v1.1.5 | Data: 2026-04-23

---

## Sumário

- [Performance](#performance)
- [UI — Interface Visual](#ui--interface-visual)
- [UX — Experiência do Usuário](#ux--experiência-do-usuário)
- [Acessibilidade](#acessibilidade)
- [Bugs e Problemas Técnicos](#bugs-e-problemas-técnicos)
- [Segurança](#segurança)

---

## Performance

### P1 — Áudios e imagens ausentes do cache do Service Worker (CRÍTICO)

**Problema:** O `sw.js` cacheia apenas os arquivos de código (`index.html`, `style.css`, `script.js`). Os 16 arquivos de áudio (`.aac`) e a imagem `pelotao.jpg` (228KB) ficam de fora do cache. Isso significa que o app pode ser instalado como PWA e ainda assim falhar ao tentar reproduzir qualquer toque offline.

**Solução:** Adicionar todos os assets estáticos à lista de cache no Service Worker.

```javascript
// sw.js — versão corrigida
const CACHE_NAME = "cefs-cache-v2";
const urlsToCache = [
  "/",
  "/index.html",
  "/style.css",
  "/script.js",
  "/manifest.json",
  "/pelotao.jpg",
  "/icon-192.png",
  "/icon-512.png",
  "/audios/sentido.aac",
  "/audios/descansar.aac",
  "/audios/apresentar-arma.aac",
  // ... todos os demais arquivos .aac
];
```

---

### P2 — Algoritmo de embaralhamento enviesado

**Problema:** A função `embaralhar()` usa `.sort(() => 0.5 - Math.random())`, que é um embaralhamento incorreto. Esse método não produz distribuição uniforme — algumas questões aparecem com muito mais frequência do que outras no simulado.

**Solução:** Usar o algoritmo Fisher-Yates, que garante distribuição estatisticamente uniforme:

```javascript
function embaralhar(array) {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}
```

---

### P3 — Recriação total do DOM a cada interação

**Problema:** Toda troca de tela usa `conteudo.innerHTML = \`...\`` para jogar fora o DOM inteiro e recriá-lo do zero. Em dispositivos de baixa especificação isso pode causar flickers (piscadas) perceptíveis.

**Solução (simples):** Adicionar uma transição CSS no elemento `#conteudo` para suavizar a troca:

```css
#conteudo {
  animation: fadeIn 0.15s ease;
}
```

**Solução (avançada):** Usar `DocumentFragment` e atualizar apenas as partes do DOM que mudam, em vez de substituir tudo.

---

### P4 — Imagem do pelotão sem compressão e sem lazy-loading

**Problema:** `pelotao.jpg` tem 228KB sem nenhuma otimização. Só é exibida na aba "Informações", mas é carregada junto com todo o resto.

**Solução:**
- Converter para WebP (economia de ~40–60% no tamanho).
- Adicionar o atributo `loading="lazy"` na tag `<img>` para adiar o carregamento até o usuário abrir a aba.

```html
<img src="pelotao.jpg" alt="Foto do Pelotão Delta" loading="lazy" decoding="async" />
```

---

### P5 — Fontes do Google carregadas de forma bloqueante

**Problema:** O `<link>` do Google Fonts no `<head>` bloqueia a renderização inicial da página enquanto baixa os arquivos de fonte da internet.

**Solução:** Adicionar `rel="preconnect"` e carregar a fonte de forma assíncrona com `media="print"`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" media="print" onload="this.media='all'">
<noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"></noscript>
```

---

## UI — Interface Visual

### UI1 — Ausência de feedback visual durante o carregamento do áudio

**Problema:** Ao pressionar "Ouvir", nada acontece visualmente enquanto o arquivo de áudio está sendo baixado/bufferizado. O botão não dá retorno ao usuário.

**Solução:** Mudar o texto e o estado do botão enquanto o áudio carrega:

```javascript
function tocarAudio(caminho, botao) {
  if (botao) {
    botao.textContent = "Carregando...";
    botao.disabled = true;
  }
  const audio = new Audio(caminho);
  audio.addEventListener("canplay", () => {
    if (botao) {
      botao.textContent = "▶ Ouvir";
      botao.disabled = false;
    }
    audio.play();
  });
  audio.addEventListener("error", () => {
    if (botao) botao.textContent = "Erro ao carregar";
  });
}
```

---

### UI2 — Indicador de progresso no simulado

**Problema:** O simulado mostra "Questão X de 10" em texto puro, mas não existe nenhuma barra ou indicador visual de progresso.

**Solução:** Adicionar uma barra de progresso acima do card de questão:

```html
<div class="progress-bar">
  <div class="progress-fill" style="width: ${(indiceAtual / 10) * 100}%"></div>
</div>
```

```css
.progress-bar {
  height: 6px;
  background: #e0e0e0;
  border-radius: 3px;
  margin-bottom: 16px;
  overflow: hidden;
}
.progress-fill {
  height: 100%;
  background: #3b5bff;
  border-radius: 3px;
  transition: width 0.3s ease;
}
```

---

### UI3 — Feedback visual no resultado (acertos/erros)

**Problema:** A tela de resultado mostra apenas "X de 10 acertos" em texto. Não há distinção visual entre uma boa e uma má pontuação.

**Solução:** Colorir o resultado de acordo com a performance:

```javascript
const cor = acertos >= 8 ? "#34c759"  // Verde — ótimo
          : acertos >= 5 ? "#ff9500"  // Laranja — razoável
          : "#ff3b30";                 // Vermelho — ruim

// Aplicar cor ao elemento do placar
document.querySelector(".placar").style.color = cor;
```

Adicionar também um emoji contextual (✅ / ⚠️ / ❌) junto ao placar.

---

### UI4 — Botão de silenciar/parar áudio em reprodução

**Problema:** Uma vez que o áudio começa a tocar, não há como pausá-lo ou pará-lo — o usuário precisa esperar acabar.

**Solução:** Adicionar um botão "⏹ Parar" que aparece enquanto o áudio está em reprodução, e escondê-lo quando terminar:

```javascript
audioAtual.addEventListener("ended", () => {
  btnParar.style.display = "none";
});
```

---

### UI5 — Tipografia dos "bizus" muito apagada

**Problema:** A dica mnemônica (bizu) dos cards usa `font-size: 13px` e cor `#888`, tornando difícil a leitura — especialmente ao sol, que é quando o app seria mais usado.

**Solução:** Aumentar o contraste e o tamanho:

```css
.card-bizu {
  font-size: 14px;
  color: #555;       /* era #888 */
  font-weight: 500;  /* era 400 */
}
```

---

### UI6 — Ícones da navegação inferior sem rótulo de texto

**Problema:** Os botões da `bottom-nav` usam apenas emojis (🎺, 📝, ℹ️) sem texto. Em telas menores ou para usuários não familiarizados, o significado não é imediato.

**Solução:** Adicionar legendas abaixo dos ícones:

```html
<button onclick="mostrarLista()">
  <span class="nav-icon">🎺</span>
  <span class="nav-label">Toques</span>
</button>
```

```css
.bottom-nav button {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
}
.nav-label {
  font-size: 10px;
}
```

---

### UI7 — Ausência de estado ativo na navegação

**Problema:** Não há nenhum indicador de qual aba está ativa no momento. O usuário não sabe "onde está" no app.

**Solução:** Marcar o botão ativo com uma classe CSS e aplicar estilo diferenciado:

```javascript
function setNavAtiva(aba) {
  document.querySelectorAll(".bottom-nav button").forEach(btn => {
    btn.classList.toggle("ativo", btn.dataset.aba === aba);
  });
}
```

```css
.bottom-nav button.ativo {
  color: #3b5bff;
  border-top: 2px solid #3b5bff;
}
```

---

## UX — Experiência do Usuário

### UX1 — Sem confirmação ao sair do simulado no meio

**Problema:** Se o usuário está no simulado e acidentalmente toca em "Toques" ou "Informações", a prova é abandonada sem aviso. Todo o progresso é perdido.

**Solução:** Exibir um diálogo de confirmação antes de sair da prova:

```javascript
function navegarComConfirmacao(destino) {
  if (provaAtual.length > 0 && indiceAtual < provaAtual.length) {
    if (!confirm("Você está no meio do simulado. Deseja sair e perder o progresso?")) return;
  }
  provaAtual = [];
  destino();
}
```

---

### UX2 — Sem histórico de desempenho entre sessões

**Problema:** O app não salva nenhum histórico de resultados. O usuário não consegue acompanhar sua evolução ao longo do tempo.

**Solução:** Usar `localStorage` para salvar os últimos resultados e exibi-los na tela de resultado ou na aba "Informações":

```javascript
function salvarResultado(acertos) {
  const historico = JSON.parse(localStorage.getItem("historico") || "[]");
  historico.push({ data: new Date().toLocaleDateString("pt-BR"), acertos });
  if (historico.length > 10) historico.shift(); // Manter apenas os últimos 10
  localStorage.setItem("historico", JSON.stringify(historico));
}
```

---

### UX3 — Simulado sempre com 10 questões fixas

**Problema:** O usuário não tem controle sobre a quantidade de questões no simulado. Quem quer uma revisão rápida precisa passar pelo ciclo completo de 10 questões.

**Solução:** Oferecer uma seleção antes de iniciar o simulado:

```html
<div class="opcoes-simulado">
  <p>Quantas questões?</p>
  <button onclick="iniciarProva(5)">5 questões</button>
  <button onclick="iniciarProva(10)">10 questões</button>
  <button onclick="iniciarProva(15)">Todas (15)</button>
</div>
```

---

### UX4 — Áudio não reinicia ao pressionar "Ouvir" novamente

**Problema:** Se o áudio já está tocando e o usuário pressiona "Ouvir" de novo, o comportamento atual pausa e reinicia, mas de forma abrupta. Não há feedback de que o áudio reiniciou.

**Solução:** Garantir reset explícito com animação visual no botão:

```javascript
if (audioAtual) {
  audioAtual.pause();
  audioAtual.currentTime = 0;
}
// Adicionar classe de "pulsação" no botão para indicar reinício
botaoOuvir.classList.add("pulsing");
setTimeout(() => botaoOuvir.classList.remove("pulsing"), 300);
```

---

### UX5 — Sem modo "Estudo Focado" por toque individual

**Problema:** O modo lista mostra todos os toques, mas não permite que o usuário entre em modo de estudo focado em um toque específico (ouvir → ver bizu → ouvir de novo em loop).

**Solução:** Adicionar um botão "Estudar este toque" em cada card da lista que leva a uma tela de estudo focado com o toque selecionado, reprodução em loop e o bizu destacado.

---

### UX6 — Toast de instalação do PWA aparece imediatamente

**Problema:** O banner de instalação do PWA aparece logo após o carregamento, antes do usuário sequer explorar o app. Isso é considerado uma má prática de UX e pode ser rejeitado antes de qualquer interação.

**Solução:** Adicionar um atraso mínimo de 30 segundos ou esperar que o usuário complete ao menos uma ação antes de exibir o banner:

```javascript
let interacoes = 0;
function contarInteracao() {
  interacoes++;
  if (interacoes >= 3 && deferredPrompt) mostrarToastInstalacao();
}
```

---

### UX7 — Ausência de atalho para repetir a prova com os erros

**Problema:** Ao terminar o simulado, a única opção é "Tentar Novamente" com 10 questões aleatórias. Não há como repetir apenas os toques que o usuário errou.

**Solução:** Salvar os toques errados durante o simulado e oferecer um botão "Revisar meus erros":

```javascript
let erros = [];

// Ao registrar erro:
function registrarErro(toque) {
  erros.push(toque);
}

// Na tela de resultado:
if (erros.length > 0) {
  html += `<button onclick="iniciarProvaComErros()">Revisar ${erros.length} erro(s)</button>`;
}
```

---

## Acessibilidade

### A1 — Imagens sem texto alternativo

Todas as tags `<img>` devem ter atributo `alt` descritivo:

```html
<img src="pelotao.jpg" alt="Foto do Pelotão Delta CEFS A 2026" />
```

---

### A2 — Botões sem rótulos acessíveis

Os botões de play usam texto como "▶ Ouvir", mas sem atributo `aria-label` que descreva qual toque está sendo reproduzido:

```html
<button aria-label="Ouvir toque: Sentido" onclick="tocarAudio(...)">▶ Ouvir</button>
```

---

### A3 — Contraste insuficiente em textos secundários

Os textos com cor `#888` em fundo branco ficam abaixo do mínimo de contraste recomendado pela WCAG 2.1 (ratio mínimo de 4.5:1 para texto normal). Alterar para `#666` ou mais escuro.

---

### A4 — Sem suporte a navegação por teclado

Os botões da navegação inferior e os cards não recebem foco visível ao navegar com Tab. Adicionar:

```css
button:focus-visible {
  outline: 2px solid #3b5bff;
  outline-offset: 2px;
}
```

---

## Bugs e Problemas Técnicos

### B1 — Estado do simulado não é resetado ao navegar para outra aba

Se o usuário navegar para "Toques" no meio do simulado e voltar, as variáveis globais (`provaAtual`, `indiceAtual`, `acertos`) permanecem com os valores anteriores, podendo causar comportamento inesperado.

**Solução:** Resetar o estado ao iniciar o simulado e ao sair:

```javascript
function resetarProva() {
  provaAtual = [];
  indiceAtual = 0;
  acertos = 0;
}
```

---

### B2 — Erro sem tratamento no carregamento de áudio

Se um arquivo de áudio não for encontrado (erro 404 ou offline sem cache), a função `tocarAudio()` lança um erro não capturado no console. O usuário não recebe nenhuma mensagem.

**Solução:**

```javascript
audioAtual.addEventListener("error", () => {
  alert("Não foi possível carregar o áudio. Verifique sua conexão.");
});
```

---

### B3 — Percentual de resultado pode enganar (arredondamento)

`Math.round((acertos / 10) * 100)` com 9 acertos resulta em 90%, mas o cálculo correto já é 90. O problema ocorre se `total` for variável: 9/11 = 81,8% arredonda para 82%, mas o usuário pode esperar 81%. Usar `toFixed(0)` para deixar explícito.

---

## Segurança

### S1 — Número de telefone exposto no código-fonte

O número de suporte via WhatsApp está hard-coded no `script.js` como texto visível. Embora seja intencional para contato, considere documentar que isso é uma decisão consciente.

---

### S2 — innerHTML com dados dinâmicos

Atualmente os dados de `toques[]` são estáticos, então não há risco de XSS. Mas se no futuro os dados forem carregados de uma API, o uso de `innerHTML` com template literals pode introduzir vulnerabilidades. Considerar usar `textContent` e `createElement` para textos dinâmicos.

---

## Resumo Priorizado

| # | Item | Impacto | Esforço |
|---|------|---------|---------|
| 1 | Cachear áudios e imagens no Service Worker | Alto | Baixo |
| 2 | Corrigir algoritmo de embaralhamento | Médio | Baixo |
| 3 | Feedback visual durante carregamento do áudio | Alto | Baixo |
| 4 | Barra de progresso no simulado | Médio | Baixo |
| 5 | Estado ativo na navegação inferior | Médio | Baixo |
| 6 | Confirmar saída do simulado | Alto | Baixo |
| 7 | Tratamento de erro no carregamento de áudio | Alto | Baixo |
| 8 | Histórico de desempenho com localStorage | Médio | Médio |
| 9 — | Revisar erros do simulado | Alto | Médio |
| 10 | Opção de quantidade de questões | Médio | Médio |
| 11 | Rótulos de texto na navegação inferior | Médio | Baixo |
| 12 | Feedback visual no resultado (cores) | Médio | Baixo |
| 13 | Acessibilidade (alt, aria-label, foco) | Médio | Médio |
| 14 | Otimizar imagem pelotao.jpg (WebP + lazy) | Baixo | Baixo |
| 15 | Carregamento assíncrono das fontes | Baixo | Baixo |
