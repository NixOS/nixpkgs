{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-polystat-panel";
  version = "2.1.16";
  zipHash = "sha256-Lxug7dL33I5VDtwE5cZLa6LyCOMF244ETYY/ORvndTc=";
  meta = {
    description = "Hexagonal multi-stat panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
