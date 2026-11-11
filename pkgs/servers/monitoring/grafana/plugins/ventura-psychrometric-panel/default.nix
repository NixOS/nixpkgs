{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Grafana plugin to display air conditions on a psychrometric chart";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
