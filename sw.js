const CACHE_NAME = "cefs-cache-v11";

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
  "/audios/direita-volver.aac",
  "/audios/esquerda-volver.aac",
  "/audios/meiavolta.aac",
  "/audios/ombro-arma.aac",
  "/audios/descansar-arma.aac",
  "/audios/cruzar-arma.aac",
  "/audios/ordinario-marche.aac",
  "/audios/cobrir.aac",
  "/audios/firme.aac",
  "/audios/alto.aac",
  "/audios/olhar-direita.aac",
  "/audios/olhar-frente.aac"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(urlsToCache))
  );
  self.skipWaiting();
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request).then(response => response || fetch(event.request))
  );
});
