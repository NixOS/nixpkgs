{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.29";
  zipHash = "sha256-Z26GlIlk9RJze++VqqCwgcveewuXGAZhlOkXOp/pbKU=";
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = lib.platforms.unix;
  };
}
