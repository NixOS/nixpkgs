{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-echarts-panel";
  version = "6.4.1";
  zipHash = "sha256-RHOfFKplZs0gbD/esvrpXkkPKPfo5R4zjCUJWPpkDNU=";
  meta = with lib; {
    description = "The Apache ECharts plugin is a visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
