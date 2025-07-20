{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "7.0.0";
  zipHash = "sha256-ibM4h96R+hvqoG9k6xz+2xlhK1xQPb2F1BLt+mQVSxo=";
  meta = with lib; {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
