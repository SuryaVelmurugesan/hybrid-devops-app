const express = require('express');
const client = require('prom-client');
const app = express();
const register = client.register;

// simple gauge for demo
const gauge = new client.Gauge({ name: 'example_gauge', help: 'Example gauge' });
setInterval(() => gauge.set(Math.random() * 10), 5000);

app.get('/', (req, res) => res.send('Hello from DevOps Capstone!'));
app.get('/health', (req, res) => res.json({ status: 'ok', time: new Date().toISOString() }));

// Prometheus metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`App listening on ${port}`));
