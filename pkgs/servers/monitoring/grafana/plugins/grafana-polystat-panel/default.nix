{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-polystat-panel";
  version = "2.1.14";
  zipHash = "sha256-W6qx3b8rmIQV6Sm2rUsCDKrWi69N2S31hbmuqjYt25M=";
  meta = {
    description = "Hexagonal multi-stat panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
