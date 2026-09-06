const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { getPool, sql } = require('./src/config/db');

const app = express();
app.use(cors());
app.use(express.json());

// Ruta de prueba: verifica conexión a la base de datos
app.get('/api/test', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().query('SELECT GETDATE() AS fecha');
    res.json({ mensaje: 'Conexión exitosa', data: result.recordset });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
