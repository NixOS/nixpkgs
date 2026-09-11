{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "influxdb";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Support for InfluxDB data sources";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
