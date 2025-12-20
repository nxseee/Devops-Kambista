const http = require('http');

const hostname = process.env.HOST || '0.0.0.0';
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('X-Powered-By', 'Node.js');

  if (req.url === '/health') {
    res.statusCode = 200;
    return res.end(JSON.stringify({
      status: 'OK',
      uptime: process.uptime()
    }));
  }

  res.statusCode = 200;
  res.end(JSON.stringify({
    message: 'Hola Mundo',
    author: 'Andre Rivero',
    stack: 'Node.js + Nginx',
    deployment: 'Packer'
  }));
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}`);
});
