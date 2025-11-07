{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "2.1.9";
  zipHash = "sha256-awc1bA3MHg0z7HDzqhhWOymVPeEsOHUdxX0xneOd7kY=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
