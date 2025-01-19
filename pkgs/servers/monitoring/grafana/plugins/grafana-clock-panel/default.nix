{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clock-panel";
  version = "2.1.8";
  zipHash = "sha256-QLvq2CSlJuEaYAazn8MoY3XCiXeRILj4dTp/aqrHL/k=";
  meta = {
    description = "Clock panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
