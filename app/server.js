require('dotenv').config();
const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;

// Ruta principal
app.get('/', (req, res) => {
  res.send(`
    <h1>Información del Sistema</h1>
    <p>Entorno: ${process.env.NODE_ENV}</p>
    <p>Versión: ${process.env.VERSION}</p>
  `);
});

// Ruta 1: Información del servidor
app.get('/info', (req, res) => {
  res.json({
    message: 'Servidor funcionando correctamente',
    environment: process.env.NODE_ENV,
    version: process.env.VERSION
  });
});

// Ruta 2: Hora actual
app.get('/time', (req, res) => {
  res.json({
    currentTime: new Date().toLocaleString()
  });
});

// Iniciar servidor
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
  });
}

module.exports = app;