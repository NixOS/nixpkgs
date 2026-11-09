{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
