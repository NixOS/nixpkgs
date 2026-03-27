{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "7.2.4";
  zipHash = "sha256-ZqTGG3UlRqpSCITBFB5g7gIE9vxHS8VZ0Gchcfr9Dko=";
  meta = {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
