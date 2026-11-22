{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-polystat-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Hexagonal multi-stat panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
  };
}
