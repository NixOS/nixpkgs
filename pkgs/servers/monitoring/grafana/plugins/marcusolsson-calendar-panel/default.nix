{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  version = "4.2.0";
  zipHash = "sha256-GQcLaeTvbHTdbH5NWa0SL5rUP9WTQOqy38ndZb4/rA8=";
  meta = with lib; {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
