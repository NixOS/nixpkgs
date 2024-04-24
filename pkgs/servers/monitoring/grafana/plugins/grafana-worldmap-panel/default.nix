{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-worldmap-panel";
  version = "1.0.6";
  zipHash = "sha256-/lgsdBEL9HdJX1X1Qy0THBlYdUUI8SRtgF1Wig1Ktpk=";
  meta = with lib; {
    description = "World Map panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
