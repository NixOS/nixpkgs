{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.33";
  zipHash = "sha256-zQ9XwF4gUlsR5bGZVzQq/cXCLwrQ3xfYQK2jOZyrWH4=";
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = lib.platforms.unix;
  };
}
