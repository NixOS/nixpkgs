{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.10";
  zipHash = "sha256-+6/KbYgBmBxllilxhoukPy6OZcOrgrAmxS143vda2Og=";
  meta = with lib; {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
