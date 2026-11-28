{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "canvas";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Grafana visualization panel plugin";
    license = lib.licenses.agpl3Only;

    maintainers = with lib.maintainers; [ p-h ];
  };
}
