{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "7.1.0";
  zipHash = "sha256-J4FhMh50+zcBpURQgIoVZQxQaNy0oYk/7SbIqQjkEyA=";
  meta = with lib; {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
