{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  version = "3.10.1";
  zipHash = "sha256-9qM1iJXwm/tChI02C+rK7FkN2k8bQVEZJtdn9sHjVxg=";
  meta = {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
