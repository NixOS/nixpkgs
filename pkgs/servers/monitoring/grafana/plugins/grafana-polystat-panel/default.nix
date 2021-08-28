{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-polystat-panel";
  version = "1.2.3";
  zipHash = "sha256-Eu3dTPfJxAWwqqGT6l4El4MqviBbzERarU30OXU+eEM=";
  meta = with lib; {
    description = "Hexagonal multi-stat panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
