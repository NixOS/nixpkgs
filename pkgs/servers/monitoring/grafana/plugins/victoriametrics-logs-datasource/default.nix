{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.14.3";
  zipHash = "sha256-g/ntmNyWJ9h/eYpZ0gqiESvVfm2fU6/Ci8R7FHIV7AQ=";
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.unix;
  };
}
