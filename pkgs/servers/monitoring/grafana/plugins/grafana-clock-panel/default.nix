{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clock-panel";
  version = "2.1.8";
  zipHash = "sha256-QLvq2CSlJuEaYAazn8MoY3XCiXeRILj4dTp/aqrHL/k=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
