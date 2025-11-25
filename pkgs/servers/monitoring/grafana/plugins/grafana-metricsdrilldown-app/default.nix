{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.23";
  zipHash = "sha256-ZQYVKLmIFsK9+u8lVR4Y/gVTtv0klDaSM7Yh+oe0qOE=";
  meta = with lib; {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
