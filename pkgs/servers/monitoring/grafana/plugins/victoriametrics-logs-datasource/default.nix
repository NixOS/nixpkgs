{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.22.4";
  zipHash = "sha256-xDq8p86N2tgzFaNoE5/r4hgFc560bVl7VWGGL2teHuA=";
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
