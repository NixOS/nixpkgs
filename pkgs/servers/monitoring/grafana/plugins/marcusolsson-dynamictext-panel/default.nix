{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Dynamic, data-driven text panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ herbetom ];
  };
}
