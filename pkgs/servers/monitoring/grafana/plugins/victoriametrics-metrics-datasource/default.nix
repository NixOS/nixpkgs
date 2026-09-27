{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-metrics-datasource";
  version = "0.25.2";
  zipHash = "sha256-yHvzgimj49NCa2A1cm9W6AYwlXsVQXwBY6t7C72DuyU=";
  meta = {
    description = "VictoriaMetrics metrics datasource for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.shawn8901 ];
    platforms = lib.platforms.unix;
  };
}
