{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.24";
  zipHash = "sha256-aoivPnxr8/8EQhz3hD/WAgvfwQ3nUXWjs22izx7yDp8=";
  meta = with lib; {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
