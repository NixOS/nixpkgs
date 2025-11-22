{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "3.1.0";
  zipHash = "sha256-9z1hPkRloNno4qflrpLMDWdepVf45O+dLOIAhYTXKB4=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
