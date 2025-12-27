{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.25";
  zipHash = "sha256-qN4o0u9Lh/jLjQEcdWp/pOwfz+jqss8esukGeI1y3Ps=";
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = lib.platforms.unix;
  };
}
