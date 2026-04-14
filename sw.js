// ── Change ce numéro à chaque déploiement pour forcer la mise à jour ──
const VERSION = 'v8';
const CACHE = `robot-ar-${VERSION}`;
const ASSETS = ['/robot-ar/', '/robot-ar/index.html', '/robot-ar/manifest.json'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  e.respondWith(
    caches.match(e.request).then(cached => {
      if (e.request.url.endsWith('/') || e.request.url.includes('index.html')) {
        return fetch(e.request).then(res => {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
          return res;
        }).catch(() => cached);
      }
      return cached || fetch(e.request);
    })
  );
});
