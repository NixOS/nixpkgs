{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-worldmap-panel";
  version = "1.0.3";
  zipHash = "sha256-xpcQTymxA4d8jRnHm4cHAFOzPT1BseOaX0Qeq5vDvac=";
  meta = with lib; {
    description = "World Map panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
