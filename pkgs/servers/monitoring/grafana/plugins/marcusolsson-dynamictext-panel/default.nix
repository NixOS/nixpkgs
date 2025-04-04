{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  version = "5.6.0";
  zipHash = "sha256-UDJG6KAaothSv26SHKo1HNQwVHg5slI01rmDnGgGBWs=";
  meta = with lib; {
    description = "Dynamic, data-driven text panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.unix;
  };
}
