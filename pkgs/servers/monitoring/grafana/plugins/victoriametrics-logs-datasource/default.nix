{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.21.1";
  zipHash = "sha256-mhGxUt+JWX4i/CYcJOAYpCszF4F2ieaosERVoFUg/mU=";
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      samw
      shawn8901
    ];
    platforms = lib.platforms.unix;
  };
}
