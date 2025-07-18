{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.5";
  zipHash = "sha256-87BiMGdIUxtbzZjIm3+XMbM8IFlsUOBDruyUwJm2hmU=";
  meta = with lib; {
    description = "The Grafana Metrics Drilldown app provides a queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries.";
    license = licenses.agpl3Only;
    teams = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
