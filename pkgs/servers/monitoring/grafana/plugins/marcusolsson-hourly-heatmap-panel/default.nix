{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-hourly-heatmap-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "A panel plugin for Grafana to visualize hourly heatmaps";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tebriel ];
  };
}
