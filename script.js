const toques = [
  { id: 1, nome: "Sentido", audio: "audios/sentido.aac", bizu:"Aluno só fica em sentido"  },
  { id: 2, nome: "Descansar", audio: "audios/descansar.aac", bizu: "Des-can-sar" },
  { id: 3, nome: "Apresentar Arma", audio: "audios/apresentar-arma.aac", bizu: "Trás, trás, trás sua irmã pra mim!" },
  { id: 4, nome: "Direita volver", audio: "audios/direita-volver.aac", bizu: "Ooolha...ali!" },
  { id: 5, nome: "Esquerda volver", audio: "audios/esquerda-volver.aac", bizu: "Olha, olha, olha... ali!" },
  { id: 6, nome: "Meia volta volver", audio: "audios/meiavolta.aac", bizu: "Nunca vi mulher solteira... pari" },
  { id: 7, nome: "Ombro arma", audio: "audios/ombro-arma.aac", bizu: "Faz ombro arma" },
  { id: 8, nome: "Descansar arma", audio: "audios/descansar-arma.aac", bizu: "Descansar... arma!" },
  { id: 9, nome: "Cruzar arma", audio: "audios/cruzar-arma.aac", bizu:"Cruzar, cruzar, cruzar!" },
  { id: 10, nome: "Ordinário marche", audio: "audios/ordinario-marche.aac", bizu: "" },
  { id: 11, nome: "Cobrir", audio: "audios/cobrir.aac", bizu: "Soldaaado vamos cobrir!" },
  { id: 12, nome: "Firme", audio: "audios/firme.aac", bizu: "Ai meu Deus que dor!" },
  { id: 13, nome: "Alto", audio: "audios/alto.aac", bizu: "Faz alto!" },
  { id: 14, nome: "Olhar a direita", audio: "audios/olhar-direita.aac", bizu: "" },
  { id: 15, nome: "Olhar frente", audio: "audios/olhar-frente.aac", bizu: "Em frente vamos olhar!" }
];

const conteudo = document.getElementById("conteudo");

let provaAtual = [];
let indiceAtual = 0;
let acertos = 0;

let audioAtual = null;

function tocarAudio(caminho) {

  
  if (audioAtual) {
    audioAtual.pause();
    audioAtual.currentTime = 0;
  }

  
  audioAtual = new Audio(caminho);
  audioAtual.play();
}

function embaralhar(array) {
  return [...array].sort(() => 0.5 - Math.random());
}

/*LISTA */

function mostrarLista() {
  conteudo.innerHTML = "";

  toques.forEach(t => {
    const card = document.createElement("div");
    card.className = "card";

    card.innerHTML = `
      <div class="card-top">
        <div class="card-icon">🎺</div>
        <div class="card-text">
          <h2>${t.nome}</h2>
          <small>${t.bizu}</small>
          <p>CEFS A 2026 - Pelotão Delta</p>
        </div>
      </div>

      <div class="card-actions">
        <button class="btn-primary" onclick="tocarAudio('${t.audio}')">
          ▶ Ouvir
        </button>
      </div>
    `;

    conteudo.appendChild(card);
  });
}

/* PROVA */

function iniciarProva() {
  provaAtual = embaralhar(toques).slice(0, 10);
  indiceAtual = 0;
  acertos = 0;
  mostrarQuestao();
}

function mostrarQuestao() {
  const toque = provaAtual[indiceAtual];

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>Questão ${indiceAtual + 1} de 10</h2>
      <button class="btn-primary" onclick="tocarAudio('${toque.audio}')">
        ▶ Ouvir Toque
      </button>
      <br><br>
      <button class="btn-primary" onclick="mostrarResposta()">
        Mostrar Resposta
      </button>
    </div>
  `;
}

function mostrarResposta() {
  const toque = provaAtual[indiceAtual];

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>${toque.nome}</h2>
      
      <div class="bizu-prova">
      <strong>Bizu:</strong>
        ${toque.bizu}
      </div>

      <br>

      <button class="btn-primary" 
              onclick="tocarAudio('${toque.audio}')">
         Ouvir Novamente
      </button>

      <br><br>

      <p>Você acertou?</p>
      <br>

      <button class="btn-primary" onclick="responder(true)">
        ✅ Acertei
      </button>

      <br><br>

      <button class="btn-primary" onclick="responder(false)">
        ❌ Errei
      </button>
    </div>
  `;
}

function responder(acertou) {
  if (acertou) acertos++;

  indiceAtual++;

  if (indiceAtual < provaAtual.length) {
    mostrarQuestao();
  } else {
    mostrarResultado();
  }
}

function mostrarResultado() {
  const percentual = Math.round((acertos / 10) * 100);

  conteudo.innerHTML = `
    <div class="card prova-card">
      <h2>Resultado Final</h2>
      <p>${acertos} de 10</p>
      <p>${percentual}% de aproveitamento</p>
      <br>
      <button class="btn-primary" onclick="iniciarProva()">
        Refazer Prova
      </button>
    </div>
  `;
}

mostrarLista();

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("sw.js");
}

let deferredPrompt;

const installToast = document.getElementById("installToast");
const btnInstall = document.getElementById("btnInstall");
const btnClose = document.getElementById("btnClose");

// Detecta se pode instarl o PWA
window.addEventListener("beforeinstallprompt", (e) => {
  e.preventDefault();
  deferredPrompt = e;

  // toast
  installToast.classList.remove("hidden");
});

// Botão instalar
btnInstall.addEventListener("click", async () => {
  installToast.classList.add("hidden");

  if (deferredPrompt) {
    deferredPrompt.prompt();
    await deferredPrompt.userChoice;
    deferredPrompt = null;
  }
});

// Botão fechar
btnClose.addEventListener("click", () => {
  installToast.classList.add("hidden");
});

function isIOS() {
  return /iphone|ipad|ipod/i.test(window.navigator.userAgent);
}

function isInStandaloneMode() {
  return ('standalone' in window.navigator) && (window.navigator.standalone);
}

window.addEventListener("load", () => {

  // Se for iPhone e não estiver instalado
  if (isIOS() && !isInStandaloneMode()) {

    const installToast = document.getElementById("installToast");

    installToast.innerHTML = `
      <div class="toast-content">
        <strong>Instale o app no seu iPhone</strong>
        <p>
          Toque no botão <b>Compartilhar</b> (⬆️) no Safari
          e selecione <b>Adicionar à Tela de Início</b>.
        </p>
        <div class="toast-buttons">
          <button id="btnCloseIOS">Entendi</button>
        </div>
      </div>
    `;

    installToast.classList.remove("hidden");

    document.getElementById("btnCloseIOS")
      .addEventListener("click", () => {
        installToast.classList.add("hidden");
      });
  }
});