{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
