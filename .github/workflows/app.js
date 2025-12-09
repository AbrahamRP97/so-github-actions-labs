const express = require('express');
const app = express();
const port = 3000;

// Main route
app.get('/', (req, res) => {
  res.send(`
    <h1>Aplicación de Conceptos Avanzados de SO</h1>
    <p>Sistema Operativo: ${process.platform}</p>
    <p>Versión de Node.js: ${process.version}</p>
    <p>Arquitectura: ${process.arch}</p>
    <p>Memoria utilizada: ${Math.round(process.memoryUsage().heapUsed / 1024 / 1024)} MB</p>
  `);
});

// System information route
app.get('/info', (req, res) => {
  res.json({
    platform: process.platform,
    nodeVersion: process.version,
    architecture: process.arch,
    uptime: process.uptime(),
    memoryUsage: process.memoryUsage()
  });
});

// Start server
app.listen(port, () => {
  console.log(`Aplicación ejecutándose en puerto ${port}`);
  console.log(`Sistema Operativo: ${process.platform}`);
});
