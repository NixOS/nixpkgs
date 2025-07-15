{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-metricsdrilldown-app";
  version = "1.0.6";
  zipHash = "sha256-cUSpm5iyijXBEDwx+yfp3Ta68DhP37oQoi19eyAs16A=";
  meta = with lib; {
    description = "The Grafana Metrics Drilldown app provides a queryless experience for browsing Prometheus-compatible metrics. Quickly find related metrics without writing PromQL queries.";
    license = licenses.agpl3Only;
    teams = [ lib.maintainers.marcel ];
    platforms = platforms.unix;
  };
}
