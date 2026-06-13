/* Cache-first service worker. Everything is local (sounds are synthesised),
   so once cached the app runs with no network at all. Bump CACHE to force an update.
   In dev (localhost / LAN IP) it switches to pure network passthrough so edits
   always show immediately and never get masked by a stale cache. */
const CACHE = "bowl-v8";
const host = self.location.hostname;
const DEV = host === "localhost" || host === "127.0.0.1" ||
  /^(192\.168\.|10\.|172\.(1[6-9]|2\d|3[01])\.)/.test(host) || host.endsWith(".local");
const ASSETS = [
  ".",
  "index.html",
  "manifest.webmanifest",
  "icon-192.png",
  "icon-512.png",
  "icon-maskable-512.png",
  "apple-touch-icon.png"
];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", e => {
  if (e.request.method !== "GET") return;
  if (DEV) return;   // dev: let the browser hit the network directly — always fresh
  e.respondWith(
    caches.match(e.request).then(hit =>
      hit || fetch(e.request).then(res => {
        const copy = res.clone();
        caches.open(CACHE).then(c => c.put(e.request, copy)).catch(() => {});
        return res;
      }).catch(() => caches.match("index.html"))
    )
  );
});
