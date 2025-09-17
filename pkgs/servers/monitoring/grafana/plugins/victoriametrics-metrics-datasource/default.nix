{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-metrics-datasource";
  version = "0.19.0";
  zipHash = "sha256-xHo052LaMw5pzAp1EcPBpP9n7c2QTzHSZRUUe/2mQgs=";
  meta = {
    description = "VictoriaMetrics metrics datasource for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.shawn8901 ];
    platforms = lib.platforms.unix;
  };
}
