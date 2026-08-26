{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "2.5.0";
  zipHash = "sha256-AVWcT2SORlVYmHjTNX50S+3CKbtsuM1fRU290qfGYcs=";
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = lib.platforms.unix;
  };
}
