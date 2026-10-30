{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "bsull-console-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Grafana data source which can connect to the Tokio console subscriber";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
