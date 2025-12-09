{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "7.2.2";
  zipHash = "sha256-4y7L8SSqjtQ2bk+v8FeZsZ8gTd9qnBvi2F9cNLPjKGE=";
  meta = with lib; {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
