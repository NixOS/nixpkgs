{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-metrics-datasource";
  version = "0.19.4";
  zipHash = "sha256-gpbBPyzWWiz9cENBWEHyDqBRMXypiEDDgdYFuQnsD5o=";
  meta = {
    description = "VictoriaMetrics metrics datasource for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.shawn8901 ];
    platforms = lib.platforms.unix;
  };
}
