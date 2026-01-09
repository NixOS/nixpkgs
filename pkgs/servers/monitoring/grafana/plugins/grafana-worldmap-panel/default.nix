{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-worldmap-panel";
  version = "1.0.6";
  zipHash = "sha256-/lgsdBEL9HdJX1X1Qy0THBlYdUUI8SRtgF1Wig1Ktpk=";
  meta = {
    description = "World Map panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
