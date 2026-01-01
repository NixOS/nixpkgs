{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-echarts-panel";
  version = "7.2.2";
  zipHash = "sha256-4y7L8SSqjtQ2bk+v8FeZsZ8gTd9qnBvi2F9cNLPjKGE=";
<<<<<<< HEAD
  meta = {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Visualization panel for Grafana that allows you to incorporate the popular Apache ECharts library into your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
