{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-explorer-app";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Redis Explorer plugin for Grafana";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
