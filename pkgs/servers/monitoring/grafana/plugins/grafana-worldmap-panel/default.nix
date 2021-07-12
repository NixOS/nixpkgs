{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-worldmap-panel";
  version = "0.3.3";
  zipHash = "sha256-3n1p3SvcBQMmnbnHimLBP7hauVV1IS3SMwttUWTNvb8=";
  meta = with lib; {
    description = "World Map panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
