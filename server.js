const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());
app.use(express.static(__dirname + '/public'));

const pool = new Pool({
  host: 'localhost', port: 5432, database: 'parks_db',
  user: 'postgres', password: require('./config.json').password
});

const TYPES = ['Park', 'Playground', 'Walking Track', 'Sports Ground'];

function check(b) {
  if (!b.name || b.name.trim().length < 3) return 'Name must be at least 3 letters';
  if (!TYPES.includes(b.type)) return 'Invalid type';
  if (!b.sector) return 'Sector is required';
  const lat = Number(b.lat), lng = Number(b.lng);
  if (isNaN(lat) || lat < 33 || lat > 34.5) return 'Latitude must be in Islamabad area';
  if (isNaN(lng) || lng < 72.5 || lng > 73.5) return 'Longitude must be in Islamabad area';
  return null;
}

app.get('/api/parks', async (req, res) => {
  try {
    const { type = '', sector = '' } = req.query;
    const r = await pool.query(
      `SELECT id, name, type, sector, status, ST_Y(geom) lat, ST_X(geom) lng
       FROM parks WHERE ($1 = '' OR type = $1) AND ($2 = '' OR sector ILIKE $2)
       ORDER BY id`, [type, sector ? `%${sector}%` : '']);
    res.json(r.rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/parks', async (req, res) => {
  const err = check(req.body);
  if (err) return res.status(400).json({ error: err });
  const { name, type, sector, status, lat, lng } = req.body;
  try {
    const r = await pool.query(
      `INSERT INTO parks (name, type, sector, status, geom)
       VALUES ($1,$2,$3,$4, ST_SetSRID(ST_MakePoint($6,$5),4326)) RETURNING id`,
      [name, type, sector, status || 'Open', lat, lng]);
    res.json({ message: 'Added', id: r.rows[0].id });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.put('/api/parks/:id', async (req, res) => {
  const err = check(req.body);
  if (err) return res.status(400).json({ error: err });
  const { name, type, sector, status, lat, lng } = req.body;
  try {
    const r = await pool.query(
      `UPDATE parks SET name=$1, type=$2, sector=$3, status=$4,
       geom = ST_SetSRID(ST_MakePoint($6,$5),4326) WHERE id=$7`,
      [name, type, sector, status, lat, lng, req.params.id]);
    if (r.rowCount === 0) return res.status(404).json({ error: 'Not found' });
    res.json({ message: 'Updated' });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.delete('/api/parks/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM parks WHERE id=$1', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.listen(3000, () => console.log('Server running at http://localhost:3000'));
