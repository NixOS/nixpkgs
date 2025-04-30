{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  version = "3.9.1";
  zipHash = "sha256-52MhkjsTke256cId6BtgjdRiU4w9cA6MTWA79/UfHQw=";
  meta = with lib; {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
