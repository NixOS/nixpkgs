{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-polystat-panel";
  version = "1.2.5";
  zipHash = "sha256-U9vNfK4ofNzwL7MVe43tGY85gI56Jt1eb7TrCkeNrOQ=";
  meta = with lib; {
    description = "Hexagonal multi-stat panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
