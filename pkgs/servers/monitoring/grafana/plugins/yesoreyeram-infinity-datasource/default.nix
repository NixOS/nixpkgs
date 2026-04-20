{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  version = "3.7.4";
  zipHash = "sha256-XRMbMRzTYGnoIN6rXefhiigZ6FX6MkF2yjlwB3bMqDQ=";
  meta = {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
