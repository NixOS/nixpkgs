{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-polystat-panel";
  version = "2.1.4";
  zipHash = "sha256-15mi5NzbbWXJ/69VEwUS058atQ+z2g4C3T9/b+/Exwk=";
  meta = with lib; {
    description = "Hexagonal multi-stat panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
