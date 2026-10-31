{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
