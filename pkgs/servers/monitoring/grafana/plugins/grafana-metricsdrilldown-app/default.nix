{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
<<<<<<< HEAD
  version = "1.0.26";
  zipHash = "sha256-XLcsIH8gxWYRlPUy9WGwsxQClj13Ct/xHLh2pseJYB0=";
  meta = {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = lib.platforms.unix;
=======
  version = "1.0.23";
  zipHash = "sha256-ZQYVKLmIFsK9+u8lVR4Y/gVTtv0klDaSM7Yh+oe0qOE=";
  meta = with lib; {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
