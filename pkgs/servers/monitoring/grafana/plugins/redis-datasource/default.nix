{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Redis Data Source for Grafana";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
