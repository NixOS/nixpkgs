{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-worldmap-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "World Map panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
  };
}
