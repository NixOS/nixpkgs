{
  buildEnv,
  influxdb2-server,
  influxdb2-cli,
}:
buildEnv {
  name = "influxdb2";
  paths = [
    influxdb2-server
    influxdb2-cli
  ];
}
