{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-echarts-panel";
  version = "6.4.1";
  zipHash = "sha256-RHOfFKplZs0gbD/esvrpXkkPKPfo5R4zjCUJWPpkDNU=";
  meta = {
    description = "The Apache ECharts plugin is a visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
