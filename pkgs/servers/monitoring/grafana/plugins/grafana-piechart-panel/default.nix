{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-piechart-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Pie chart panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
  };
}
