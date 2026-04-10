{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "2.0.1";
  zipHash = "sha256-fZVp+Bd5o10doJlzDFSfPgjI33XG+lUnGcOFwERYxBY=";
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = lib.platforms.unix;
  };
}
