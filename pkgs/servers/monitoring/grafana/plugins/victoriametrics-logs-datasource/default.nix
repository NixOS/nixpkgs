{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.21.0";
  zipHash = "sha256-KesSzORt243WS9sR+iinq+wRI6q+8MPn8o9Bj2ic6E0=";
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
