const toques = [
  { id: 1,  nome: "Sentido",           audio: "audios/sentido.aac",          bizu: "Aluno só fica em sentido" },
  { id: 2,  nome: "Descansar",         audio: "audios/descansar.aac",         bizu: "Des-can-sar" },
  { id: 3,  nome: "Apresentar Arma",   audio: "audios/apresentar-arma.aac",   bizu: "Trás, trás, trás sua irmã pra mim!" },
  { id: 4,  nome: "Direita volver",    audio: "audios/direita-volver.aac",    bizu: "Ooolha...ali!" },
  { id: 5,  nome: "Esquerda volver",   audio: "audios/esquerda-volver.aac",   bizu: "Olha, olha, olha... ali!" },
  { id: 6,  nome: "Meia volta volver", audio: "audios/meiavolta.aac",         bizu: "Nunca vi mulher solteira... pari" },
  { id: 7,  nome: "Ombro arma",        audio: "audios/ombro-arma.aac",        bizu: "Faz ombro arma" },
  { id: 8,  nome: "Descansar arma",    audio: "audios/descansar-arma.aac",    bizu: "Descansar... arma!" },
  { id: 9,  nome: "Cruzar arma",       audio: "audios/cruzar-arma.aac",       bizu: "Cruzar, cruzar, cruzar!" },
  { id: 10, nome: "Ordinário marche",  audio: "audios/ordinario-marche.aac",  bizu: "" },
  { id: 11, nome: "Cobrir",            audio: "audios/cobrir.aac",            bizu: "Soldaaado vamos cobrir!" },
  { id: 12, nome: "Firme",             audio: "audios/firme.aac",             bizu: "Ai meu Deus que dor!" },
  { id: 13, nome: "Alto",              audio: "audios/alto.aac",              bizu: "Faz alto!" },
  { id: 14, nome: "Olhar a direita",   audio: "audios/olhar-direita.aac",     bizu: "" },
  { id: 15, nome: "Olhar frente",      audio: "audios/olhar-frente.aac",      bizu: "Em frente vamos olhar!" }
];

const conteudo = document.getElementById("conteudo");

let provaAtual = [];
let indiceAtual = 0;
let acertos = 0;
let erros = [];
let audioAtual = null;
let botaoAtual = null;
let modoAtual = 'classico'; // 'classico' | 'multipla'

// --- ÁUDIO ---

function icon(nome) {
  return `<i data-lucide="${nome}"></i>`;
}

function setBotao(botao, icone, texto, desabilitado) {
  if (!botao) return;
  botao.innerHTML = `${icon(icone)} ${texto}`;
  botao.disabled = desabilitado;
  lucide.createIcons();
}

function tocarAudio(caminho, botao) {
  if (botaoAtual === botao && audioAtual && !audioAtual.paused) {
    audioAtual.pause();
    audioAtual.currentTime = 0;
    audioAtual = null;
    setBotao(botao, "play", "Reproduzir", false);
    botaoAtual = null;
    return;
  }

  if (audioAtual) {
    audioAtual.pause();
    audioAtual.currentTime = 0;
  }

  if (botaoAtual && botaoAtual !== botao) {
    setBotao(botaoAtual, "play", "Reproduzir", false);
  }

  botaoAtual = botao || null;
  setBotao(botao, "loader-2", "Carregando...", true);

  audioAtual = new Audio(caminho);

  function onReady() {
    setBotao(botao, "square", "Reproduzindo...", false);
    audioAtual.play().catch(() => setBotao(botao, "play", "Reproduzir", false));
  }

  audioAtual.addEventListener("ended", () => {
    setBotao(botao, "play", "Reproduzir", false);
    botaoAtual = null;
  }, { once: true });

  audioAtual.addEventListener("error", () => {
    setBotao(botao, "play", "Reproduzir", false);
    botaoAtual = null;
    alert("Não foi possível carregar o áudio. Verifique sua conexão ou reinstale o app.");
  }, { once: true });

  if (audioAtual.readyState >= 3) {
    onReady();
  } else {
    audioAtual.addEventListener("canplay", onReady, { once: true });
  }
}

// --- MÉTRICAS ---

function getMetricas() {
  return JSON.parse(localStorage.getItem("cefs-metricas") || "{}");
}

function salvarMetricas(metricas) {
  localStorage.setItem("cefs-metricas", JSON.stringify(metricas));
}

function getMetricaToque(id) {
  return getMetricas()[id] || { acertos: 0, erros: 0, sequencia: 0, ultimaVez: null, dominio: "aprendendo" };
}

function calcularDominio(sequencia) {
  if (sequencia >= 6) return "dominado";
  if (sequencia >= 3) return "bom";
  return "aprendendo";
}

function atualizarMetrica(toqueId, acertou) {
  const metricas = getMetricas();
  const m = metricas[toqueId] || { acertos: 0, erros: 0, sequencia: 0, ultimaVez: null, dominio: "aprendendo" };
  if (acertou) { m.acertos++; m.sequencia++; }
  else         { m.erros++;   m.sequencia = 0; }
  m.ultimaVez = new Date().toISOString();
  m.dominio = calcularDominio(m.sequencia);
  metricas[toqueId] = m;
  salvarMetricas(metricas);
}

function tempoRelativo(iso) {
  if (!iso) return null;
  const dias = Math.floor((Date.now() - new Date(iso).getTime()) / 86400000);
  if (dias === 0) return "hoje";
  if (dias === 1) return "ontem";
  return `há ${dias} dias`;
}

const DOMINIO_LABEL = { aprendendo: "Aprendendo", bom: "Bom", dominado: "Dominado" };

// --- UTILITÁRIOS ---

function embaralhar(array) {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

function resetarProva() {
  provaAtual = [];
  indiceAtual = 0;
  acertos = 0;
  erros = [];
}

function setNavAtiva(aba) {
  document.querySelectorAll(".bottom-nav button").forEach(btn => {
    btn.classList.toggle("ativo", btn.dataset.aba === aba);
  });
}

function navegarPara(destino) {
  if (provaAtual.length > 0 && indiceAtual < provaAtual.length) {
    if (!confirm("Você está no meio do simulado. Deseja sair e perder o progresso?")) return;
    resetarProva();
  }
  destino();
}

// --- LISTA ---

function renderResumoProgresso() {
  const metricas = getMetricas();
  const praticados = toques.map(t => metricas[t.id]).filter(Boolean);
  if (praticados.length === 0) return "";

  const counts = { aprendendo: 0, bom: 0, dominado: 0 };
  praticados.forEach(m => counts[m.dominio]++);
  const naoIniciados = toques.length - praticados.length;
  counts.aprendendo += naoIniciados;

  const pct = Math.round((counts.dominado / toques.length) * 100);

  return `
    <div class="card resumo-progresso">
      <div class="resumo-header">
        <h3>Seu Progresso</h3>
        <span class="resumo-pct">${pct}% dominado</span>
      </div>
      <div class="resumo-barra-geral">
        <div class="resumo-fill-aprendendo" style="width:${Math.round((counts.aprendendo/toques.length)*100)}%"></div>
        <div class="resumo-fill-bom"        style="width:${Math.round((counts.bom/toques.length)*100)}%"></div>
        <div class="resumo-fill-dominado"   style="width:${Math.round((counts.dominado/toques.length)*100)}%"></div>
      </div>
      <div class="resumo-legenda">
        <span><span class="dot dot-aprendendo"></span> Aprendendo <strong>${counts.aprendendo}</strong></span>
        <span><span class="dot dot-bom"></span> Bom <strong>${counts.bom}</strong></span>
        <span><span class="dot dot-dominado"></span> Dominado <strong>${counts.dominado}</strong></span>
      </div>
    </div>
  `;
}

function mostrarLista() {
  setNavAtiva("lista");
  conteudo.innerHTML = renderResumoProgresso();

  toques.forEach(t => {
    const m = getMetricaToque(t.id);
    const total = m.acertos + m.erros;
    const taxa = total > 0 ? Math.round((m.acertos / total) * 100) : null;
    const quando = tempoRelativo(m.ultimaVez);

    const metricasHTML = `
      <div class="card-metricas">
        <span class="badge-dominio badge-${m.dominio}">${DOMINIO_LABEL[m.dominio]}</span>
        ${taxa !== null ? `<span class="metrica-info">${taxa}% acerto</span>` : ''}
        ${m.sequencia >= 2 ? `<span class="metrica-sequencia">🔥 ${m.sequencia} seguidos</span>` : ''}
        ${quando ? `<span class="metrica-info">${quando}</span>` : ''}
      </div>
    `;

    const card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `
      <div class="card-top">
        <div class="card-icon"><i data-lucide="music-2"></i></div>
        <div class="card-text">
          <h2>${t.nome}</h2>
          ${t.bizu ? `<small>${t.bizu}</small>` : ''}
          ${metricasHTML}
        </div>
      </div>
      <div class="card-actions">
        <button class="btn-primary"
                aria-label="Reproduzir toque: ${t.nome}"
                onclick="tocarAudio('${t.audio}', this)">
          <i data-lucide="play"></i> Reproduzir
        </button>
      </div>
    `;
    conteudo.appendChild(card);
  });

  lucide.createIcons();
}

// --- SIMULADO ---

function mostrarSimulado() {
  setNavAtiva("simulado");
  resetarProva();

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>Treino</h2>
      <p class="subtitulo-simulado">Escolha o modo</p>
      <div class="opcoes-simulado">
        <button class="btn-modo" onclick="selecionarModo('classico')">
          <i data-lucide="headphones"></i>
          <div>
            <strong>Modo Clássico</strong>
            <span>Ouça e identifique o toque</span>
          </div>
        </button>
        <button class="btn-modo" onclick="selecionarModo('multipla')">
          <i data-lucide="list-checks"></i>
          <div>
            <strong>Múltipla Escolha</strong>
            <span>Escolha entre 4 alternativas</span>
          </div>
        </button>
      </div>
    </div>
  `;
  lucide.createIcons();
}

function selecionarModo(modo) {
  modoAtual = modo;
  const titulo = modo === 'multipla' ? 'Múltipla Escolha' : 'Modo Clássico';

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>${titulo}</h2>
      <p class="subtitulo-simulado">Quantas questões?</p>
      <div class="opcoes-simulado">
        <button class="btn-primary" onclick="iniciarProva(5)">5 questões</button>
        <button class="btn-primary" onclick="iniciarProva(10)">10 questões</button>
        <button class="btn-primary" onclick="iniciarProva(${toques.length})">Todas (${toques.length})</button>
        <button class="btn-secundario" onclick="mostrarSimulado()">← Voltar</button>
      </div>
    </div>
  `;
}

function iniciarProva(total) {
  provaAtual = embaralhar(toques).slice(0, total);
  indiceAtual = 0;
  acertos = 0;
  erros = [];
  modoAtual === 'multipla' ? mostrarQuestaoMC() : mostrarQuestao();
}

function iniciarProvaComErros() {
  provaAtual = embaralhar(erros);
  indiceAtual = 0;
  acertos = 0;
  erros = [];
  modoAtual === 'multipla' ? mostrarQuestaoMC() : mostrarQuestao();
}

function mostrarQuestao() {
  const toque = provaAtual[indiceAtual];
  const total = provaAtual.length;
  const progresso = (indiceAtual / total) * 100;

  conteudo.innerHTML = `
    <div class="progress-bar">
      <div class="progress-fill" style="width: ${progresso}%"></div>
    </div>
    <div class="card prova-card">
      <h2>Toque ${indiceAtual + 1} de ${total}</h2>
      <button class="btn-primary"
              aria-label="Reproduzir toque ${indiceAtual + 1} de ${total}"
              onclick="tocarAudio('${toque.audio}', this)">
        <i data-lucide="play"></i> Reproduzir Toque
      </button>
      <br><br>
      <button class="btn-primary" onclick="mostrarResposta()">
        Mostrar Resposta
      </button>
    </div>
  `;

  lucide.createIcons();
}

function mostrarQuestaoMC() {
  const toque = provaAtual[indiceAtual];
  const total = provaAtual.length;
  const progresso = (indiceAtual / total) * 100;

  const erradas = embaralhar(toques.filter(t => t.id !== toque.id)).slice(0, 3);
  const opcoes = embaralhar([toque, ...erradas]);

  const opcoesHTML = opcoes.map(op => `
    <button class="btn-opcao"
            data-correto="${op.id === toque.id}"
            onclick="responderMC(${op.id === toque.id}, this)">
      ${op.nome}
    </button>
  `).join('');

  conteudo.innerHTML = `
    <div class="progress-bar">
      <div class="progress-fill" style="width: ${progresso}%"></div>
    </div>
    <div class="card prova-card">
      <p class="questao-label">Questão ${indiceAtual + 1} de ${total}</p>
      <p class="questao-instrucao">Qual é este toque?</p>
      <button class="btn-primary btn-audio-mc"
              aria-label="Reproduzir toque ${indiceAtual + 1} de ${total}"
              onclick="tocarAudio('${toque.audio}', this)">
        <i data-lucide="play"></i> Ouvir Toque
      </button>
      <div class="opcoes-mc">
        ${opcoesHTML}
      </div>
    </div>
  `;

  lucide.createIcons();
}

function responderMC(acertou, botaoClicado) {
  const toque = provaAtual[indiceAtual];
  atualizarMetrica(toque.id, acertou);
  const todosOsBotoes = document.querySelectorAll('.btn-opcao');
  todosOsBotoes.forEach(btn => { btn.disabled = true; });

  if (acertou) {
    botaoClicado.classList.add('opcao-correta');
    acertos++;
  } else {
    botaoClicado.classList.add('opcao-errada');
    erros.push(toque);
    todosOsBotoes.forEach(btn => {
      if (btn.dataset.correto === 'true') btn.classList.add('opcao-correta');
    });
    if (toque.bizu) {
      const hint = document.createElement('div');
      hint.className = 'hint-bizu';
      hint.innerHTML = `<i data-lucide="lightbulb"></i> <span><strong>${toque.nome}:</strong> <em>"${toque.bizu}"</em></span>`;
      document.querySelector('.opcoes-mc').appendChild(hint);
      lucide.createIcons();
    }
  }

  if (audioAtual) {
    audioAtual.pause();
    audioAtual.currentTime = 0;
    audioAtual = null;
    botaoAtual = null;
  }

  const delay = acertou ? 1300 : 2100;
  setTimeout(() => {
    indiceAtual++;
    if (indiceAtual < provaAtual.length) {
      mostrarQuestaoMC();
    } else {
      mostrarResultado();
    }
  }, delay);
}

function mostrarResposta() {
  const toque = provaAtual[indiceAtual];
  const total = provaAtual.length;
  const progresso = (indiceAtual / total) * 100;

  conteudo.innerHTML = `
    <div class="progress-bar">
      <div class="progress-fill" style="width: ${progresso}%"></div>
    </div>
    <div class="card prova-card">
      <h2>${toque.nome}</h2>

      <div class="bizu-prova">
        <strong>Bizu:</strong> ${toque.bizu || "—"}
      </div>

      <br>

      <button class="btn-primary"
              aria-label="Reproduzir novamente: ${toque.nome}"
              onclick="tocarAudio('${toque.audio}', this)">
        <i data-lucide="play"></i> Reproduzir Novamente
      </button>

      <br><br>

      <p>Você acertou?</p>
      <br>

      <button class="btn-primary" onclick="responder(true)">
        <i data-lucide="check"></i> Acertei
      </button>

      <br><br>

      <button class="btn-primary" onclick="responder(false)">
        <i data-lucide="x"></i> Errei
      </button>
    </div>
  `;

  lucide.createIcons();
}

function responder(acertou) {
  const toque = provaAtual[indiceAtual];
  atualizarMetrica(toque.id, acertou);
  if (acertou) {
    acertos++;
  } else {
    erros.push(toque);
  }

  indiceAtual++;
  if (indiceAtual < provaAtual.length) {
    mostrarQuestao();
  } else {
    mostrarResultado();
  }
}

function mostrarResultado() {
  const total = provaAtual.length;
  const percentual = Math.round((acertos / total) * 100);

  salvarResultado(acertos, total);

  const classeResultado = percentual >= 80 ? "resultado-otimo"
                        : percentual >= 50 ? "resultado-medio"
                        : "resultado-ruim";

  const iconeResultado = percentual >= 80
    ? '<i data-lucide="check-circle"></i>'
    : percentual >= 50
    ? '<i data-lucide="alert-triangle"></i>'
    : '<i data-lucide="x-circle"></i>';

  const btnErros = erros.length > 0
    ? `<button class="btn-primary btn-erros" onclick="mostrarRevisaoErros()">
         <i data-lucide="rotate-cw"></i> Praticar ${erros.length} erro(s)
       </button><br><br>`
    : "";

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>Resultado Final</h2>
      <div class="resultado-placar ${classeResultado}">
        <span class="resultado-emoji">${iconeResultado}</span>
        <span class="resultado-numero">${acertos}/${total}</span>
        <span class="resultado-percentual">${percentual}% de aproveitamento</span>
      </div>
      <br>
      ${btnErros}
      <button class="btn-primary" onclick="mostrarSimulado()">
        Novo Simulado
      </button>
      ${renderHistorico()}
    </div>
  `;

  lucide.createIcons();
}

function mostrarRevisaoErros() {
  const lista = [...erros];

  const itensHTML = lista.map(t => `
    <div class="erro-item">
      <div class="erro-info">
        <span class="erro-nome">${t.nome}</span>
        ${t.bizu ? `<span class="erro-bizu">"${t.bizu}"</span>` : ''}
      </div>
      <button class="btn-play-mini"
              aria-label="Reproduzir ${t.nome}"
              onclick="tocarAudio('${t.audio}', this)">
        <i data-lucide="play"></i>
      </button>
    </div>
  `).join('');

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>Revisão de Erros</h2>
      <p class="subtitulo-simulado">${lista.length} toque(s) para praticar — ouça antes de começar</p>
      <div class="erros-lista">
        ${itensHTML}
      </div>
      <br>
      <button class="btn-primary btn-erros" onclick="iniciarProvaComErros()">
        <i data-lucide="rotate-cw"></i> Iniciar Quiz
      </button>
      <br><br>
      <button class="btn-secundario" onclick="mostrarSimulado()">Voltar ao início</button>
    </div>
  `;

  lucide.createIcons();
}

function salvarResultado(acertos, total) {
  const historico = JSON.parse(localStorage.getItem("cefs-historico") || "[]");
  historico.push({ data: new Date().toLocaleDateString("pt-BR"), acertos, total });
  if (historico.length > 5) historico.shift();
  localStorage.setItem("cefs-historico", JSON.stringify(historico));
}

function renderHistorico() {
  const historico = JSON.parse(localStorage.getItem("cefs-historico") || "[]");
  if (historico.length <= 1) return "";

  const itens = historico.slice(0, -1).reverse().map(h => {
    const pct = Math.round((h.acertos / h.total) * 100);
    return `<div class="historico-item"><span>${h.data}</span><span>${h.acertos}/${h.total} (${pct}%)</span></div>`;
  }).join("");

  return `
    <div class="historico">
      <h3>Histórico Recente</h3>
      ${itens}
    </div>
  `;
}

// --- INFO ---

function mostrarInfo() {
  setNavAtiva("info");

  conteudo.innerHTML = `
    <div class="info-container">
      <div class="info-header">
        <h2>Informações</h2>
      </div>
      <br>
      <div class="foto-container">
        <img src="/pelotao.jpg"
             alt="Foto do Pelotão Delta CEFS A 2026"
             class="foto-pelotao"
             loading="lazy"
             decoding="async">
      </div>

      <div class="card info-card">
        <h3>Sobre o App</h3>
        <p>Este aplicativo foi desenvolvido para auxiliar os alunos do <strong>CEFS A 2026 - Pelotão Delta</strong> na memorização dos toques de corneta militares.</p>
        <p>A prática através do simulado ajuda na fixação dos bizus e na agilidade de resposta durante as atividades e na prova.</p>
      </div>

      <div class="aviso-seguranca">
        <div class="aviso-icon"><i data-lucide="alert-triangle"></i></div>
        <div>
          <strong>Aviso de Estudo</strong>
          <p>Esta ferramenta é para fins educacionais. Os toques seguem o padrão regulamentar, mas sempre consulte o instrutor do seu pelotão.</p>
        </div>
      </div>

      <div class="creditos">
        <p>DESENVOLVIDO POR</p>
        <div class="dev-info">
          <strong>Pelotão Delta</strong>
          <p>Versão 1.5.0 (2026)</p>
        </div>
        <div class="info-links">
          <a href="https://wa.me/5531996338032?text=Olá! Tenho uma dúvida/sugestão sobre o App de Toques de Corneta." target="_blank" rel="noopener noreferrer">Suporte e sugestão</a>
        </div>
      </div>
    </div>
  `;

  lucide.createIcons();
}

// --- INIT ---

mostrarLista();

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("sw.js");
}

// --- PWA ---

let deferredPrompt;

const installToast = document.getElementById("installToast");
const btnInstall = document.getElementById("btnInstall");
const btnClose = document.getElementById("btnClose");

window.addEventListener("beforeinstallprompt", (e) => {
  e.preventDefault();
  deferredPrompt = e;
  setTimeout(() => {
    if (deferredPrompt) installToast.classList.remove("hidden");
  }, 10000);
});

btnInstall.addEventListener("click", async () => {
  installToast.classList.add("hidden");
  if (deferredPrompt) {
    deferredPrompt.prompt();
    await deferredPrompt.userChoice;
    deferredPrompt = null;
  }
});

btnClose.addEventListener("click", () => {
  installToast.classList.add("hidden");
});

function isIOS() {
  return /iphone|ipad|ipod/i.test(window.navigator.userAgent);
}

function isInStandaloneMode() {
  return ("standalone" in window.navigator) && (window.navigator.standalone);
}

window.addEventListener("load", () => {
  if (isIOS() && !isInStandaloneMode()) {
    installToast.innerHTML = `
      <div class="toast-content">
        <strong>Instale o app no seu iPhone</strong>
        <p>
          Toque no botão <b>Compartilhar</b> no Safari
          e selecione <b>Adicionar à Tela de Início</b>.
        </p>
        <div class="toast-buttons">
          <button id="btnCloseIOS">Entendi</button>
        </div>
      </div>
    `;

    setTimeout(() => installToast.classList.remove("hidden"), 10000);

    document.getElementById("btnCloseIOS").addEventListener("click", () => {
      installToast.classList.add("hidden");
    });
  }
});
