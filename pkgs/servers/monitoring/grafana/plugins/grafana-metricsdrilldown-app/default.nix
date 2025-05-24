{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.1";
  zipHash = "sha256-MJgmpm14+sd17dWBp7GGkNFVnqtBq2bxJJLtD5MIsKQ=";
  meta = with lib; {
    description = "The Grafana Metrics Drilldown app provides a queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries.";
    license = licenses.agpl3Only;
    teams = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
