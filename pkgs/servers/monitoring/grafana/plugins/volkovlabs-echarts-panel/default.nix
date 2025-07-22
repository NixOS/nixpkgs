{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "6.6.0";
  zipHash = "sha256-SjZl33xoHVmE6y0D7FT9x2wVPil7HK1rYVgTXICpXZ4=";
  meta = with lib; {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
