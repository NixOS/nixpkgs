{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "2.1.9";
  zipHash = "sha256-awc1bA3MHg0z7HDzqhhWOymVPeEsOHUdxX0xneOd7kY=";
  meta = {
    description = "Clock panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
