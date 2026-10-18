{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Developer-friendly incident response for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
  };
}
