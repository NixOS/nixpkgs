{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-calendar-panel";
  version = "2.3.1";
  zipHash = "sha256-yU0qU/kclxco5+r+8JS7VRMVAsrpNNEdoUEWYhNU2T0=";
  meta = with lib; {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
