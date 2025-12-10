{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "3.2.0";
  zipHash = "sha256-aKt0Cr0GSAz1mVdb//PKajgkOe2TlS7HC/HTvuTlNf4=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
