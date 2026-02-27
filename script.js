const toques = [
  { id: 1, nome: "Sentido", audio: "audios/sentido.aac" },
  { id: 2, nome: "Descansar", audio: "audios/descansar.aac" },
  { id: 3, nome: "Apresentar Arma", audio: "audios/apresentar-arma.aac" },
  { id: 4, nome: "Direita volver", audio: "audios/direita-volver.aac" },
  { id: 5, nome: "Esquerda volver", audio: "audios/esquerda-volver.aac" },
  { id: 6, nome: "Meia volta volver", audio: "audios/meia-volta.aac" },
  { id: 7, nome: "Ombro arma", audio: "audios/ombro-arma.aac" },
  { id: 8, nome: "Descansar arma", audio: "audios/descansar-arma.aac" },
  { id: 9, nome: "Cruzar arma", audio: "audios/cruzar-arma.aac" },
  { id: 10, nome: "Ordinário marche", audio: "audios/ordinario-marche.aac" },
  { id: 11, nome: "Cobrir", audio: "audios/cobrir.aac" },
  { id: 12, nome: "Firme", audio: "audios/firme.aac" },
  { id: 13, nome: "Alto", audio: "audios/alto.aac" },
  { id: 14, nome: "Olhar a direita", audio: "audios/olhar-direita.aac" },
  { id: 15, nome: "Olhar frente", audio: "audios/olhar-frente.aac" }
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
          <p>CEFS A 2026 - Pel Delta</p>
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
      <p>Marque seu resultado abaixo</p>
      <br>
      <button class="btn-primary" onclick="responder(true)">
        ✅ Acertei!
      </button>
      <br><br>
      <button class="btn-primary" onclick="responder(false)">
        ❌ Errei!
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