{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Clock panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
  };
}
