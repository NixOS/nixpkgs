{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  version = "4.2.0";
  zipHash = "sha256-GQcLaeTvbHTdbH5NWa0SL5rUP9WTQOqy38ndZb4/rA8=";
  meta = {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
