{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-metrics-datasource";
  version = "0.21.0";
  zipHash = "sha256-S+MKGEIZ3dq2sN8yxR/Cuos/AXV66aXololLY7BaJco=";
  meta = {
    description = "VictoriaMetrics metrics datasource for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.shawn8901 ];
    platforms = lib.platforms.unix;
  };
}
