{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.19.3";
  zipHash = "sha256-UMHcH4o6/Wr7Wct977HdOiXgvXo0j9LfZxPcRCqG2+U=";
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.unix;
  };
}
