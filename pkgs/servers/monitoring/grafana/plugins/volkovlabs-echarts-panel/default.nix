{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "7.2.5";
  zipHash = "sha256-5J9SDu+S85HRHHepT1UDtUBFHp51XamsXLNVOo5ds7U=";
  meta = {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
