module.exports = {
  apps: [{
    name: "nodemgr",
    script: "app.js",
    args: ['-H', '127.0.0.1', '-S', '-S', '-A', CN],
    watch: true,
  }]
};
