{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.26.2";
  zipHash = "sha256-m/ckiKhlrHNlbkXjvqXbNYogoI6QyEa1thBQmga5V/4=";
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
