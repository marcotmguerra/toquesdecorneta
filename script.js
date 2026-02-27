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

function tocarAudio(event, caminho) {
  event.stopPropagation();
  const audio = new Audio(caminho);
  audio.play();
}

function criarCard(toque, mostrarNome = false) {
  const card = document.createElement("div");
  card.className = "card";

  card.innerHTML = `
    <h2>${mostrarNome ? toque.nome : "Toque " + toque.id}</h2>
    <button onclick="tocarAudio(event, '${toque.audio}')">▶ Ouvir</button>
  `;

  card.addEventListener("click", () => {
    card.classList.toggle("virado");
    card.querySelector("h2").textContent =
      card.classList.contains("virado")
        ? toque.nome
        : "Toque " + toque.id;
  });

  return card;
}

function mostrarLista() {
  conteudo.innerHTML = "";
  toques.forEach(t => {
    conteudo.appendChild(criarCard(t, true));
  });
}

function iniciarSimulado() {
  conteudo.innerHTML = "";

  const embaralhado = [...toques].sort(() => 0.5 - Math.random());
  const selecionados = embaralhado.slice(0, 10);

  selecionados.forEach(t => {
    conteudo.appendChild(criarCard(t));
  });
}

mostrarLista();

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("sw.js");
}
