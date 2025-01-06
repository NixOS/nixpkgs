{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-polystat-panel";
  version = "2.1.13";
  zipHash = "sha256-O8YOSVLhJ1hDNbBHKwkikNBOjQTrGofGklVTalgDH4I=";
  meta = {
    description = "Hexagonal multi-stat panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lukegb ];
    platforms = lib.platforms.unix;
  };
}
