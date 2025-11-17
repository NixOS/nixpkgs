{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-polystat-panel";
  version = "2.1.15";
  zipHash = "sha256-l6jhlnZ9E8OdCHcX0HMpD1VjShq+mtBYeciPNkzsjlA=";
  meta = with lib; {
    description = "Hexagonal multi-stat panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
