{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-metrics-datasource";
  version = "0.22.0";
  zipHash = "sha256-wawH2b95KX7KXIJot4tThTB1tT0XKzUjFsL2hzM5TX8=";
  meta = {
    description = "VictoriaMetrics metrics datasource for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.shawn8901 ];
    platforms = lib.platforms.unix;
  };
}
