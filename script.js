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
let audioCtx = null;

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

// --- CONFIGURAÇÕES ---

function getConfig() {
  return JSON.parse(localStorage.getItem("cefs-config") || '{"som":true,"haptico":true}');
}

function salvarConfig(config) {
  localStorage.setItem("cefs-config", JSON.stringify(config));
}

function toggleConfig(chave) {
  const config = getConfig();
  config[chave] = !config[chave];
  salvarConfig(config);
}

// --- FEEDBACK ---

function getAudioCtx() {
  if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
  if (audioCtx.state === 'suspended') audioCtx.resume();
  return audioCtx;
}

function tocarSomAcerto() {
  if (!getConfig().som) return;
  const ctx = getAudioCtx();
  const t = ctx.currentTime;
  [523, 784].forEach((freq, i) => {
    const osc  = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.frequency.value = freq;
    gain.gain.setValueAtTime(0.22, t + i * 0.11);
    gain.gain.exponentialRampToValueAtTime(0.001, t + i * 0.11 + 0.18);
    osc.start(t + i * 0.11);
    osc.stop(t + i * 0.11 + 0.18);
  });
}

function tocarSomErro() {
  if (!getConfig().som) return;
  const ctx = getAudioCtx();
  const t = ctx.currentTime;
  const osc  = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.connect(gain);
  gain.connect(ctx.destination);
  osc.type = 'triangle';
  osc.frequency.setValueAtTime(260, t);
  osc.frequency.exponentialRampToValueAtTime(160, t + 0.22);
  gain.gain.setValueAtTime(0.2, t);
  gain.gain.exponentialRampToValueAtTime(0.001, t + 0.28);
  osc.start(t);
  osc.stop(t + 0.28);
}

function vibrar(padrao) {
  if (!getConfig().haptico) return;
  if ('vibrate' in navigator) navigator.vibrate(padrao);
}

function tocarSomConquista() {
  if (!getConfig().som) return;
  const ctx = getAudioCtx();
  const t = ctx.currentTime;
  [523, 659, 784, 1047].forEach((freq, i) => {
    const osc  = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.frequency.value = freq;
    gain.gain.setValueAtTime(0.2, t + i * 0.12);
    gain.gain.exponentialRampToValueAtTime(0.001, t + i * 0.12 + 0.28);
    osc.start(t + i * 0.12);
    osc.stop(t + i * 0.12 + 0.28);
  });
}

function iniciarConfetti(canvas) {
  const ctx = canvas.getContext('2d');
  canvas.width  = window.innerWidth;
  canvas.height = window.innerHeight;

  const cores = ['#3b5bff', '#2ecc71', '#f5c542', '#ff6b35', '#e74c3c', '#9b59b6'];
  const particulas = Array.from({ length: 90 }, () => ({
    x:      Math.random() * canvas.width,
    y:      Math.random() * canvas.height - canvas.height,
    w:      Math.random() * 10 + 5,
    h:      Math.random() * 6  + 3,
    cor:    cores[Math.floor(Math.random() * cores.length)],
    vx:     Math.random() * 4 - 2,
    vy:     Math.random() * 3 + 1.5,
    angulo: Math.random() * Math.PI * 2,
    vang:   Math.random() * 0.15 - 0.075,
  }));

  let frame;
  function animar() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particulas.forEach(p => {
      p.x      += p.vx;
      p.y      += p.vy;
      p.angulo += p.vang;
      p.vy     += 0.06;
      ctx.save();
      ctx.translate(p.x, p.y);
      ctx.rotate(p.angulo);
      ctx.fillStyle = p.cor;
      ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h);
      ctx.restore();
    });
    frame = requestAnimationFrame(animar);
  }
  animar();
  setTimeout(() => cancelAnimationFrame(frame), 2800);
}

function mostrarConquistaDominado(nomeToque) {
  vibrar([50, 30, 50, 30, 120]);
  tocarSomConquista();

  const overlay = document.createElement('div');
  overlay.className = 'conquista-overlay';
  overlay.innerHTML = `
    <canvas class="confetti-canvas"></canvas>
    <div class="conquista-card">
      <div class="conquista-icon">🏆</div>
      <h2>Dominado!</h2>
      <p><strong>${nomeToque}</strong> está dominado</p>
      <small>Toque para continuar</small>
    </div>
  `;
  document.body.appendChild(overlay);

  iniciarConfetti(overlay.querySelector('.confetti-canvas'));

  const fechar = () => {
    overlay.classList.add('conquista-saindo');
    setTimeout(() => overlay.remove(), 300);
  };
  overlay.addEventListener('click', fechar);
  setTimeout(fechar, 3000);
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
  const dominioAnterior = m.dominio;
  if (acertou) { m.acertos++; m.sequencia++; }
  else         { m.erros++;   m.sequencia = 0; }
  m.ultimaVez = new Date().toISOString();
  m.dominio = calcularDominio(m.sequencia);
  metricas[toqueId] = m;
  salvarMetricas(metricas);
  return m.dominio === 'dominado' && dominioAnterior !== 'dominado';
}

function tempoRelativo(iso) {
  if (!iso) return null;
  const dias = Math.floor((Date.now() - new Date(iso).getTime()) / 86400000);
  if (dias === 0) return "hoje";
  if (dias === 1) return "ontem";
  return `há ${dias} dias`;
}

const DOMINIO_LABEL = { aprendendo: "Aprendendo", bom: "Bom", dominado: "Dominado" };

// --- SRS ---

function calcularPeso(m) {
  if (!m) return 5; // nunca praticado → máxima prioridade

  const pesoDominio = { aprendendo: 3, bom: 2, dominado: 1 };
  let peso = pesoDominio[m.dominio] || 3;

  if (m.ultimaVez) {
    const dias = (Date.now() - new Date(m.ultimaVez).getTime()) / 86400000;
    if      (dias > 7) peso += 2; // atrasado: urgente
    else if (dias > 3) peso += 1; // próximo de vencer
    else if (dias < 1) peso = Math.max(1, peso - 1); // revisado hoje: leve redução
  }

  return peso;
}

function selecionarToquesPonderados(total) {
  const metricas = getMetricas();

  // Cria pool ponderado: cada toque aparece N vezes conforme seu peso
  const pool = [];
  toques.forEach(t => {
    const peso = calcularPeso(metricas[t.id]);
    for (let i = 0; i < peso; i++) pool.push(t);
  });

  // Embaralha e extrai toques únicos na ordem resultante
  const shuffled = embaralhar(pool);
  const vistos = new Set();
  const selecionados = [];
  for (const t of shuffled) {
    if (!vistos.has(t.id)) {
      vistos.add(t.id);
      selecionados.push(t);
      if (selecionados.length === total) break;
    }
  }

  return selecionados;
}

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
      <div class="aviso-adaptativo">
        <i data-lucide="brain"></i>
        <span>Toques mais fracos e esquecidos aparecem com mais frequência</span>
      </div>
      <div class="opcoes-simulado">
        <button class="btn-primary" onclick="iniciarProva(5)">5 questões</button>
        <button class="btn-primary" onclick="iniciarProva(10)">10 questões</button>
        <button class="btn-primary" onclick="iniciarProva(${toques.length})">Todas (${toques.length})</button>
        <button class="btn-secundario" onclick="mostrarSimulado()">← Voltar</button>
      </div>
    </div>
  `;
  lucide.createIcons();
}

function iniciarProva(total) {
  provaAtual = selecionarToquesPonderados(total);
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
    <div class="progress-topo">
      <div class="progress-bar">
        <div class="progress-fill" style="width: ${progresso}%"></div>
      </div>
      <span class="badge-srs">🎯 Adaptativo</span>
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
    <div class="progress-topo">
      <div class="progress-bar">
        <div class="progress-fill" style="width: ${progresso}%"></div>
      </div>
      <span class="badge-srs">🎯 Adaptativo</span>
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
  const novoDominio = atualizarMetrica(toque.id, acertou);
  const todosOsBotoes = document.querySelectorAll('.btn-opcao');
  todosOsBotoes.forEach(btn => { btn.disabled = true; });

  if (acertou) {
    botaoClicado.classList.add('opcao-correta');
    acertos++;
    vibrar([40]);
    tocarSomAcerto();
    if (novoDominio) setTimeout(() => mostrarConquistaDominado(toque.nome), 300);
  } else {
    botaoClicado.classList.add('opcao-errada');
    erros.push(toque);
    vibrar([80, 50, 80]);
    tocarSomErro();
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
    <div class="progress-topo">
      <div class="progress-bar">
        <div class="progress-fill" style="width: ${progresso}%"></div>
      </div>
      <span class="badge-srs">🎯 Adaptativo</span>
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
  const novoDominio = atualizarMetrica(toque.id, acertou);
  if (acertou) {
    acertos++;
    vibrar([40]);
    tocarSomAcerto();
    if (novoDominio) setTimeout(() => mostrarConquistaDominado(toque.nome), 300);
  } else {
    erros.push(toque);
    vibrar([80, 50, 80]);
    tocarSomErro();
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

      <div class="card info-card config-card">
        <h3>Configurações</h3>
        <div class="toggle-row">
          <div class="toggle-label">
            <strong>Som</strong>
            <small>Efeitos sonoros ao responder</small>
          </div>
          <label class="toggle-switch">
            <input type="checkbox" ${getConfig().som ? 'checked' : ''} onchange="toggleConfig('som')">
            <span class="toggle-slider"></span>
          </label>
        </div>
        <div class="toggle-row">
          <div class="toggle-label">
            <strong>Vibração</strong>
            <small>Feedback háptico ao responder</small>
          </div>
          <label class="toggle-switch">
            <input type="checkbox" ${getConfig().haptico ? 'checked' : ''} onchange="toggleConfig('haptico')">
            <span class="toggle-slider"></span>
          </label>
        </div>
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
          <p>Versão 2.0.0 (2026)</p>
        </div>
        <div class="info-links">
          <a href="https://wa.me/5531996338032?text=Olá! Tenho uma dúvida/sugestão sobre o App de Toques de Corneta." target="_blank" rel="noopener noreferrer">Suporte e sugestão</a>
          <a href="#" onclick="event.preventDefault(); localStorage.removeItem('cefs-onboarding'); mostrarOnboarding();">Ver introdução</a>
        </div>
      </div>
    </div>
  `;

  lucide.createIcons();
}

// --- TEMA ---

function getTemaSalvo() {
  return localStorage.getItem("cefs-tema") ||
    (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
}

function aplicarTema(tema) {
  document.documentElement.setAttribute('data-theme', tema);
  localStorage.setItem("cefs-tema", tema);
  const btn = document.getElementById('btnTema');
  if (!btn) return;
  btn.innerHTML = tema === 'dark'
    ? '<i data-lucide="sun"></i>'
    : '<i data-lucide="moon"></i>';
  lucide.createIcons();
}

function toggleTema() {
  const atual = document.documentElement.getAttribute('data-theme') || 'light';
  aplicarTema(atual === 'dark' ? 'light' : 'dark');
}

// --- ONBOARDING ---

const TELAS_ONBOARDING = [
  {
    icone: '🎺',
    titulo: 'Bem-vindo ao\nToques de Corneta',
    texto: 'Aprenda a identificar os <strong>15 toques militares</strong> do CEFS A 2026. Cada toque tem um <em>bizu</em> — uma frase que ajuda a memorizar o som.',
    extra: '',
  },
  {
    icone: '🧠',
    titulo: 'Treino\ninteligente',
    texto: 'O app usa <strong>repetição espaçada</strong>: toques que você erra voltam mais cedo, enquanto os que você domina aparecem menos.',
    extra: `<div class="ob-niveis">
      <span class="badge-dominio badge-aprendendo">Aprendendo</span>
      <span class="ob-seta">→</span>
      <span class="badge-dominio badge-bom">Bom</span>
      <span class="ob-seta">→</span>
      <span class="badge-dominio badge-dominado">Dominado</span>
    </div>`,
  },
  {
    icone: '🎯',
    titulo: 'Dois modos\nde treino',
    texto: '<strong>Modo Clássico:</strong> ouça e identifique o toque.<br><br><strong>Múltipla Escolha:</strong> 4 alternativas com feedback imediato e dica do bizu ao errar.',
    extra: '',
  },
];

let telaOnboarding = 0;

function verificarOnboarding() {
  if (!localStorage.getItem("cefs-onboarding")) mostrarOnboarding();
}

function mostrarOnboarding() {
  telaOnboarding = 0;
  const overlay = document.createElement('div');
  overlay.className = 'onboarding-overlay';
  overlay.innerHTML = '<div class="onboarding-card"></div>';
  document.body.appendChild(overlay);
  renderTelaOnboarding();
}

function renderTelaOnboarding() {
  const card = document.querySelector('.onboarding-card');
  if (!card) return;
  const tela  = TELAS_ONBOARDING[telaOnboarding];
  const total = TELAS_ONBOARDING.length;
  const ultima = telaOnboarding === total - 1;

  const dots = Array.from({ length: total }, (_, i) =>
    `<span class="ob-dot ${i === telaOnboarding ? 'ob-dot-ativo' : ''}"></span>`
  ).join('');

  card.innerHTML = `
    <div class="ob-header">
      <div class="ob-dots">${dots}</div>
      ${!ultima
        ? `<button class="ob-pular" onclick="concluirOnboarding()">Pular</button>`
        : '<div></div>'}
    </div>
    <div class="ob-corpo">
      <div class="ob-icone">${tela.icone}</div>
      <h2 class="ob-titulo">${tela.titulo.replace('\n', '<br>')}</h2>
      <p class="ob-texto">${tela.texto}</p>
      ${tela.extra}
    </div>
    <button class="btn-primary ob-btn"
            onclick="${ultima ? 'concluirOnboarding()' : 'proximaTelaOnboarding()'}">
      ${ultima ? '🚀 Começar' : 'Próximo →'}
    </button>
  `;
}

function proximaTelaOnboarding() {
  const card = document.querySelector('.onboarding-card');
  if (!card) return;
  card.style.cssText = 'opacity:0;transform:translateY(10px);transition:opacity .15s,transform .15s';
  setTimeout(() => {
    telaOnboarding++;
    renderTelaOnboarding();
    requestAnimationFrame(() => {
      card.style.cssText = 'opacity:1;transform:translateY(0);transition:opacity .2s,transform .2s';
    });
  }, 150);
}

function concluirOnboarding() {
  localStorage.setItem("cefs-onboarding", "1");
  const overlay = document.querySelector('.onboarding-overlay');
  if (overlay) {
    overlay.classList.add('ob-saindo');
    setTimeout(() => overlay.remove(), 350);
  }
}

// --- INIT ---

aplicarTema(getTemaSalvo());
mostrarLista();
verificarOnboarding();

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
