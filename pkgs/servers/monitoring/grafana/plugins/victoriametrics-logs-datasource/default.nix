{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.29.0";
  zipHash = "sha256-zTZRUCWGwJ02/hewJEPclfEWlTYQU0jUUDyxuRkyRHA=";
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
