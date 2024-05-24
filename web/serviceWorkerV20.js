// Register a service worker with the browser.
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/serviceWorkerV20.js');
}

// Intercept network requests and serve cached resources.
self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
      // If the response is in the cache and is not stale, return it.
      if (response && response.ok && event.request.cache === 'only-if-cached') {
        return response;
      }

      // Otherwise, fetch the resource from the network.
      return fetch(event.request);
    })
  );
});

// Update the cache whenever a new version of the app is deployed.
self.addEventListener('updatefound', function(event) {
  event.waitUntil(
    caches.open('my-site-cache').then(function(cache) {
      // Add all of the new resources to the cache.
      cache.addAll(event.serviceWorker.active.scriptURL.split('/').slice(0, -1).concat([event.serviceWorker.registration.scope]));
    })
  );
});