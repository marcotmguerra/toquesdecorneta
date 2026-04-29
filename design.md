# Design — Toques de Corneta CEFS

> Análise e proposta de redesign baseada no `skill.md` (frontend-design skill)
> Versão atual: 2.7.3 | Data: 2026-04-29

---

## Diagnóstico do Design Atual

O app é funcional e bem estruturado tecnicamente, mas visualmente genérico. Os problemas centrais segundo os critérios do `skill.md`:

| Elemento        | Estado atual              | Problema                                            |
|-----------------|---------------------------|-----------------------------------------------------|
| Tipografia      | `Inter`                   | Fonte proibida — "generic AI slop aesthetic"        |
| Cor de acento   | `#3b5bff` (azul genérico) | Clichê, sem relação com o contexto operacional     |
| Cards           | Estilo iOS padrão         | Previsível, sem caráter próprio                     |
| Fundo           | Cor sólida flat           | Sem profundidade, atmosfera ou textura              |
| Animações       | fadeIn + slideUp básico   | Sem impacto, espalhadas sem intenção                |
| Identidade      | Nenhuma                   | App de toques sem referência visual ao contexto    |

---

## Direção Estética: "Ordem do Dia"

**Conceito:** Design operacional-neutro. Estrutura de manual técnico reinterpretada com precisão gráfica moderna. Funciona para Bombeiros, Polícia e Exército sem favorecer nenhuma corporação — como um documento de protocolo que pertence a todos.

**Tom:** Utilitarian-refined. Não é brutalismo cru nem minimalismo vazio — é disciplina com intenção. Cada elemento tem um posto.

**O que torna inesquecível:** O contraste entre a fonte display stencil nos títulos e a limpeza geométrica do corpo. O usuário sente que está usando uma ferramenta séria e institucional, não um quiz genérico de estudos.

---

## 1. Tipografia

### Problema atual
`Inter` é listada explicitamente no `skill.md` como fonte genérica a evitar. Ela não carrega nenhum significado contextual para um app militar.

### Proposta

```css
/* Google Fonts — substituir o link atual */
@import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap');

:root {
  --font-display: 'Bebas Neue', sans-serif;   /* títulos, header, números grandes */
  --font-body:    'DM Sans', sans-serif;       /* corpo, labels, textos corridos   */
  --font-mono:    'DM Mono', monospace;        /* bizus, badges, métricas          */
}
```

**Hierarquia:**
- `Bebas Neue` — fonte display stencilada, peso visual imponente, evoca placas e manuais militares. Usada no header, títulos H1/H2, número do resultado, contador de questões.
- `DM Sans` — geométrica e limpa, excelente leitura em telas pequenas. Substitui Inter no corpo.
- `DM Mono` — para os *bizus*, badges de domínio e métricas. O monospace reforça o ar técnico/documental.

### Aplicação no header
```css
header h1 {
  font-family: var(--font-display);
  font-size: 26px;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--text-1);
}
```

### Resultado na tela
```
TOQUES DE CORNETA         ← Bebas Neue, 26px, letter-spacing 2px
──────────────────
Sentido                   ← DM Sans 600, 17px
"Aluno só fica em sentido"← DM Mono, 13px, itálico
```

---

## 2. Paleta de Cores

### Problema atual
Azul `#3b5bff` não tem relação com o contexto e é a cor de acento padrão de dezenas de apps. A paleta atual poderia ser de qualquer app.

### Contexto: múltiplas forças
O app é utilizado por **Bombeiros, Polícia e Exército**. Cada força tem suas próprias cores institucionais (vermelho, azul, verde), portanto a paleta deve ser **neutra e profissional** — autoritária sem pertencer a nenhuma corporação específica.

### Proposta — Paleta "Neutro Operacional"

```css
:root {
  /* Fundos */
  --bg:        #f2f3f5;   /* Cinza frio neutro */
  --surface:   #ffffff;

  /* Textos */
  --text-1:    #111318;   /* Quase preto neutro */
  --text-2:    #4b5263;   /* Cinza-azulado médio */
  --text-3:    #9099aa;   /* Cinza claro para textos terciários */

  /* Bordas */
  --border:    #dde1e9;
  --divider:   #eceef2;

  /* Acento principal — Slate profissional */
  --accent:    #3d5a80;   /* Azul-ardósia: sóbrio, não corporativo */
  --accent-bg: #e8edf5;

  /* Sucesso */
  --success:   #1e6b45;
  --success-bg:#d4ede1;

  /* Alerta */
  --warning:   #7a5200;
  --warning-bg:#fef3d0;

  /* Erro */
  --danger:    #8b1e2a;
  --danger-bg: #fde8ea;
}

[data-theme="dark"] {
  --bg:        #13151a;   /* Preto-carvão neutro */
  --surface:   #1c1f27;

  --text-1:    #e8eaf0;
  --text-2:    #8b91a0;
  --text-3:    #52576a;

  --border:    #2c3040;
  --divider:   #232635;

  --accent:    #5b7fa6;   /* Slate mais claro no escuro */
  --accent-bg: #1a2233;

  --success:   #2e9462;
  --success-bg:#0d2518;

  --warning:   #c49a00;
  --warning-bg:#251e00;

  --danger:    #c0394a;
  --danger-bg: #280d10;
}
```

**Lógica da paleta:**
- O acento **slate** (`#3d5a80`) é neutro — não é o azul da Polícia Militar, não é o verde do Exército, não é o vermelho do Corpo de Bombeiros. É uma cor de autoridade e confiança sem identidade institucional.
- Os fundos em **cinza frio neutro** funcionam como "uniforme" para qualquer força.
- As cores de sucesso/alerta/erro são funcionais (verde, amarelo, vermelho) sem carga simbólica específica de nenhuma corporação.

---

## 3. Textura e Profundidade

### Problema atual
Fundos são cores sólidas sem nenhuma profundidade. O app não tem atmosfera.

### Proposta — Grain overlay + sutil noise

```css
/* Adicionar ao body ou .app */
.app::before {
  content: '';
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  opacity: 0.035;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  background-repeat: repeat;
  background-size: 200px 200px;
}
```

### Header com borda inferior tática
```css
header {
  border-bottom: 1px solid var(--border);
  /* Substitui o fundo flat por um degradê sutil */
  background: linear-gradient(to bottom, var(--surface), var(--bg));
}
```

### Cards com borda de acento no topo
```css
.card {
  border-radius: 12px;           /* Menos arredondado — mais severo */
  border: 1px solid var(--border);
  box-shadow: 0 2px 12px rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.04);
  position: relative;
  overflow: hidden;
}

/* Linha de acento no topo dos cards principais */
.card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 3px;
  background: linear-gradient(to right, var(--accent), transparent);
}
```

---

## 4. Identidade Visual — Ícone de Corneta

### Problema atual
O ícone `music-2` da Lucide não tem relação com corneta. É um ícone de nota musical genérico.

### Proposta
Criar um SVG inline de corneta militar simples para usar como ícone de identidade:

```html
<!-- SVG inline para o header e card-icon principal -->
<svg class="icon-corneta" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Tubo da corneta -->
  <path d="M4 20 Q8 16 14 16 L22 16 Q26 14 28 10" 
        stroke="currentColor" stroke-width="2.5" stroke-linecap="round" fill="none"/>
  <!-- Campana (bell) -->
  <path d="M28 10 Q32 8 30 4 Q26 2 24 8 L22 16" 
        stroke="currentColor" stroke-width="2" stroke-linecap="round" fill="none"/>
  <!-- Bocal -->
  <circle cx="4" cy="20" r="3" stroke="currentColor" stroke-width="2" fill="none"/>
  <!-- Válvulas (3 bolinhas) -->
  <circle cx="16" cy="13" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="13" r="1.5" fill="currentColor"/>
  <circle cx="22" cy="13" r="1.5" fill="currentColor"/>
</svg>
```

Substituir o `music-2` do Lucide pelo SVG inline no header e nos cards da lista.

---

## 5. Animações

### Problema atual
Animações estão espalhadas sem intenção clara. O `fadeIn` em 0.3s é padrão demais. Não há momento de impacto orquestrado.

### Proposta — Stagger no carregamento da lista

```css
/* Entrada dos cards com stagger */
.card {
  animation: cardEntrada 0.4s cubic-bezier(0.22, 1, 0.36, 1) both;
}

/* Atribuir delay via JS com index */
/* card.style.animationDelay = `${index * 0.05}s` */

@keyframes cardEntrada {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Botão de play — estado "tocando"

```css
/* Pulso de ondas sonoras ao reproduzir */
@keyframes sonarPulse {
  0%   { box-shadow: 0 0 0 0   color-mix(in srgb, var(--accent) 40%, transparent); }
  70%  { box-shadow: 0 0 0 10px color-mix(in srgb, var(--accent) 0%,  transparent); }
  100% { box-shadow: 0 0 0 0   color-mix(in srgb, var(--accent) 0%,  transparent); }
}

.btn-primary.tocando {
  animation: sonarPulse 1.2s ease-out infinite;
}
```

Adicionar a classe `tocando` via JS quando o áudio está em reprodução e remover ao parar.

### Transição de telas

```css
/* Substituir a recriação brusca de innerHTML */
#conteudo {
  animation: trocarTela 0.2s cubic-bezier(0.22, 1, 0.36, 1);
}

@keyframes trocarTela {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

Para aplicar ao trocar de tela, basta remover e readicionar o elemento ou usar a técnica:

```javascript
// No início de cada função mostrar*()
conteudo.style.animation = 'none';
conteudo.offsetHeight; // reflow forçado
conteudo.style.animation = '';
```

### Confetti com cores militares

```javascript
// Substituir as cores atuais no iniciarConfetti()
// Neutras: slate, cinza-azulado, branco gelo, preto-carvão, verde-sucesso, amarelo-alerta
const cores = ['#3d5a80', '#5b7fa6', '#e8eaf0', '#111318', '#1e6b45', '#c49a00'];
```

---

## 6. Barra de Navegação Inferior

### Problema atual
A barra inferior tem estilo iOS genérico com borda superior reta. Não há tratamento especial para o estado ativo.

### Proposta

```css
.bottom-nav {
  background: var(--surface);
  border-top: 2px solid var(--border);
  /* Sombra para cima */
  box-shadow: 0 -4px 20px rgba(0,0,0,0.06);
}

/* Aba ativa — destaque em bronze com pill */
.bottom-nav button.ativo {
  color: var(--accent);
}

.bottom-nav button.ativo .nav-icon {
  background: var(--accent-bg);
  border-radius: 10px;
  padding: 4px 12px;
  transition: background 0.2s;
}

/* Rótulo em maiúsculas com espaçamento */
.nav-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.8px;
  text-transform: uppercase;
  font-weight: 500;
}
```

---

## 7. Tela de Lista de Toques

### Card dos toques — redesign

```css
/* Card mais compacto com acento lateral */
.card-icon {
  width: 48px;
  height: 48px;
  background: var(--accent-bg);
  border-radius: 10px;
  border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent);
}

/* Bizu em monospace para destacar */
.card-text small {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-2);
  font-style: normal; /* remover o itálico genérico */
  border-left: 2px solid var(--accent);
  padding-left: 8px;
  margin-top: 6px;
  display: block;
}
```

### Separador de seção com rótulo tático

```html
<!-- Adicionar acima da lista de toques, agrupando por categoria -->
<div class="secao-label">
  <span>Movimentos Básicos</span>
  <div class="secao-linha"></div>
</div>
```

```css
.secao-label {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 20px 0 10px;
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  color: var(--text-3);
}

.secao-linha {
  flex: 1;
  height: 1px;
  background: var(--divider);
}
```

---

## 8. Badges de Domínio

### Problema atual
Os badges `Aprendendo`, `Bom`, `Dominado` usam cores hardcoded (azul, amarelo, verde) fora do sistema de variáveis CSS — quebram no tema escuro.

### Proposta — Progressão por variáveis do tema

```css
/* Renomear visual mantendo os textos atuais */
.badge-dominio {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.8px;
  text-transform: uppercase;
  padding: 2px 8px;
  border-radius: 4px;   /* menos arredondado — mais tático */
  border: 1px solid transparent;
}

.badge-aprendendo {
  background: transparent;
  border-color: var(--text-3);
  color: var(--text-3);        /* apagado — ainda não conquistado */
}

.badge-bom {
  background: var(--warning-bg);
  border-color: var(--warning);
  color: var(--warning);       /* amarelo-âmbar — em progresso */
}

.badge-dominado {
  background: var(--success-bg);
  border-color: var(--success);
  color: var(--success);       /* verde-sucesso — conquistado */
}
```

---

## 9. Tela de Resultado

### Problema atual
O número do resultado usa `font-size: 28px` com Inter. É uma oportunidade de impacto desperdiçada.

### Proposta

```css
/* Número do placar em Bebas Neue — impacto máximo */
.resultado-numero {
  font-family: var(--font-display);
  font-size: 72px;
  line-height: 1;
  letter-spacing: 2px;
}

.resultado-percentual {
  font-family: var(--font-mono);
  font-size: 13px;
  letter-spacing: 1px;
  text-transform: uppercase;
}

/* Cores ajustadas para a nova paleta */
.resultado-otimo { background: var(--success-bg); color: var(--success); }
.resultado-medio { background: var(--warning-bg); color: var(--warning); }
.resultado-ruim  { background: var(--danger-bg);  color: var(--danger);  }
```

---

## 10. Barra de Progresso do Simulado

### Proposta — Estilo "régua tática"

```css
.progress-bar {
  height: 4px;
  background: var(--border);
  border-radius: 0;  /* sem arredondamento — régua reta */
  position: relative;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(to right, var(--accent), color-mix(in srgb, var(--accent) 70%, var(--success)));
  transition: width 0.4s cubic-bezier(0.22, 1, 0.36, 1);
}

/* Marcadores de divisão (como graduações de uma régua) */
.progress-ticks {
  display: flex;
  justify-content: space-between;
  margin-top: 4px;
}
.progress-tick {
  width: 1px;
  height: 4px;
  background: var(--border);
}
```

---

## 11. Onboarding

### Problema atual
O fundo do card de onboarding é branco puro (`background: white` hardcoded), quebrando o tema escuro. Os ícones são os mesmos do Lucide sem tratamento especial.

### Correções obrigatórias

```css
/* Remover o `background: white` hardcoded */
.onboarding-card {
  background: var(--surface);   /* respeitar o tema */
  border-radius: 24px 24px 0 0;
}

.ob-titulo {
  font-family: var(--font-display);
  font-size: 36px;
  letter-spacing: 1px;
  line-height: 1.1;
  text-transform: uppercase;
  color: var(--text-1);
}

.ob-texto {
  font-family: var(--font-body);
  font-size: 15px;
  color: var(--text-2);
  line-height: 1.7;
}

/* Dots em bronze */
.ob-dot-ativo {
  background: var(--accent);
}
```

---

## 12. Conquista "Dominado"

### Problema atual
O card tem `background: white` hardcoded e `color: #1a7a35` fixo — quebra no tema escuro.

### Correções obrigatórias

```css
.conquista-card {
  background: var(--surface);    /* tema-aware */
}

.conquista-card h2 {
  font-family: var(--font-display);
  font-size: 42px;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--success);
}

.conquista-icon svg {
  color: var(--accent);   /* slate profissional, não laranja genérico */
}
```

---

## 13. Aviso de Segurança (Info)

### Problema atual
Background amarelo fixo `#fff9e6` quebra no dark mode (não usa variável CSS).

### Correção

```css
.aviso-seguranca {
  background: var(--warning-bg);
  border: 1px solid color-mix(in srgb, var(--warning) 30%, transparent);
  color: var(--warning);
}
```

---

## Resumo Priorizado

| # | Melhoria | Impacto Visual | Esforço |
|---|----------|----------------|---------|
| 1 | Substituir Inter por Bebas Neue + DM Sans + DM Mono | Alto | Baixo |
| 2 | Nova paleta (bronze + verde-oliva + pergaminho) | Alto | Baixo |
| 3 | Corrigir `background: white` hardcoded (onboarding, conquista) | Alto | Baixo |
| 4 | Corrigir cores fixas que quebram no dark mode (aviso, bizus, etc.) | Alto | Baixo |
| 5 | Grain overlay + border-top accent nos cards | Médio | Baixo |
| 6 | Stagger de entrada dos cards na lista | Médio | Baixo |
| 7 | Animação sonarPulse no botão durante reprodução | Médio | Baixo |
| 8 | Transição de tela ao trocar abas | Médio | Baixo |
| 9 | Badges de domínio redesenhados (estilo rank) | Médio | Baixo |
| 10 | Número do resultado em Bebas Neue 72px | Médio | Baixo |
| 11 | Nav-label em DM Mono uppercase | Baixo | Baixo |
| 12 | Ícone SVG inline de corneta | Médio | Médio |
| 13 | Separadores de seção na lista de toques | Baixo | Médio |
| 14 | Confetti com cores militares | Baixo | Baixo |

---

## O que NÃO fazer

Seguindo os critérios do `skill.md`:

- **Não usar** gradiente roxo/lilás em fundo branco — clichê absoluto.
- **Não usar** `Space Grotesk` como substituto do Inter — igualmente genérico no ecossistema atual.
- **Não usar** animações em todos os elementos — escolher 2–3 momentos de impacto real (entrada da lista, botão tocando, resultado final).
- **Não adicionar** ilustrações 3D ou ícones coloridos estilo Material Design — destoa do tom austero militar.
- **Não usar** sombras excessivas em todos os cards — reservar profundidade para elementos que realmente precisam de hierarquia.
