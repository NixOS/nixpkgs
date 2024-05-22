{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-echarts-panel";
  version = "5.1.0";
  zipHash = "sha256-0de2nlcAScumMimvEpvzwpXnynLPTmRW52G1yFwUxHg=";
  meta = with lib; {
    description = "The Apache ECharts plugin is a visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
