{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  version = "4.1.0";
  zipHash = "sha256-SQIzKCfBo0UDqwrl7ZkbHq2F+ddwviLYVQbgi+zsT20=";
  meta = with lib; {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
