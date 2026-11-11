{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-calendar-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
