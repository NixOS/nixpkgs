{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "3.0.1";
  zipHash = "sha256-DGPLSoFq6Y2FBA9EivaFwMGxhQDcoamx+DcMR6d7c9U=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
