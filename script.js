const toques = [
  { id: 1, nome: "Toque 1", audio: "audios/toque1.mp3" },
  { id: 2, nome: "Toque 2", audio: "audios/toque2.mp3" },
  { id: 3, nome: "Toque 3", audio: "audios/toque3.mp3" },
  { id: 4, nome: "Toque 4", audio: "audios/toque4.mp3" },
  { id: 5, nome: "Toque 5", audio: "audios/toque5.mp3" },
  { id: 6, nome: "Toque 6", audio: "audios/toque6.mp3" },
  { id: 7, nome: "Toque 7", audio: "audios/toque7.mp3" },
  { id: 8, nome: "Toque 8", audio: "audios/toque8.mp3" },
  { id: 9, nome: "Toque 9", audio: "audios/toque9.mp3" },
  { id: 10, nome: "Toque 10", audio: "audios/toque10.mp3" },
  { id: 11, nome: "Toque 11", audio: "audios/toque11.mp3" },
  { id: 12, nome: "Toque 12", audio: "audios/toque12.mp3" },
  { id: 13, nome: "Toque 13", audio: "audios/toque13.mp3" },
  { id: 14, nome: "Toque 14", audio: "audios/toque14.mp3" },
  { id: 15, nome: "Toque 15", audio: "audios/toque15.mp3" }
];

const conteudo = document.getElementById("conteudo");

let provaAtual = [];
let indiceAtual = 0;
let acertos = 0;

function tocarAudio(caminho) {
  const audio = new Audio(caminho);
  audio.play();
}

function embaralhar(array) {
  return [...array].sort(() => 0.5 - Math.random());
}

/* =========================
   LISTA ESTILO APP
========================= */

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
          <p>Treinamento CEFS • Áudio Oficial</p>
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

/* =========================
   PROVA REAL (flashcard mantido)
========================= */

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