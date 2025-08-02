{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  version = "4.0.1";
  zipHash = "sha256-xyqu9e6PImQmwN/p05TrSYx5uOmghbTVfoy4JT7hyqA=";
  meta = {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
