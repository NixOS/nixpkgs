{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
  };
}
