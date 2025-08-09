// Minimal static server with COOP/COEP headers for crossOriginIsolated
const path = require('path');
const express = require('express');

const app = express();
const PORT = process.env.PORT ? Number(process.env.PORT) : 3000;
const ROOT = process.cwd();

app.use((_, res, next) => {
  res.set({
    'Cross-Origin-Opener-Policy': 'same-origin',
    'Cross-Origin-Embedder-Policy': 'require-corp',
    'Cross-Origin-Resource-Policy': 'same-origin',
    'Origin-Agent-Cluster': '?1',
  });
  next();
});

app.use(express.static(ROOT));

app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`[serve] Listening on http://localhost:${PORT} (root: ${ROOT})`);
});


