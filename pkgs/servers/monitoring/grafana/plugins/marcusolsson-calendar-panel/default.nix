{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  version = "4.2.4";
  zipHash = "sha256-pqPz/wFzx3ffyMYYCoo34bof5UQ/Qz67V/E9c4QSizg=";
  meta = {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
