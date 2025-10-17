{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.17";
  zipHash = "sha256-36CpgfPJXstKqNCjfjnXzAHZshV9PdLJ2hkJneFyBLE=";
  meta = with lib; {
    description = "Queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
