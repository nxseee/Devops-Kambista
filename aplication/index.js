
const express = require("express");
const crypto = require("crypto");

const app = express();
const port = process.env.PORT || 8080;

app.use((req, res, next) => {
  const rid = req.header("x-request-id") || crypto.randomUUID();
  res.setHeader("x-request-id", rid);
  req.requestId = rid;
  next();
});

app.get("/", (req, res) => {
  console.log(JSON.stringify({
    severity: "INFO",
    message: "Hola Mundo by Andre Rivero",
    requestId: req.requestId,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString()
  }));
  res.json({ ok: true, message: "Hello World", requestId: req.requestId });
});

app.get("/healthz", (_req, res) => res.status(200).send("ok"));

app.listen(port, () => {
  console.log(JSON.stringify({
    severity: "INFO",
    message: "Service started",
    port,
    timestamp: new Date().toISOString()
  }));
});
