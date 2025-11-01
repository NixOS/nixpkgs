{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.19";
  zipHash = "sha256-rnBT10qZCeWdCMNHCFN2yLfIJUCkneIo0IIhj6xxKew=";
  meta = with lib; {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
