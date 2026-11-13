{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-app";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Redis Application plugin for Grafana";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
