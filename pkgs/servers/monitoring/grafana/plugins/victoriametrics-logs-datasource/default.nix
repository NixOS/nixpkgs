{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.16.3";
  zipHash = "sha256-C7xYnhRd6KC+prZwL0vINriMb1mvFxMattLp8N8A8tE=";
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.unix;
  };
}
