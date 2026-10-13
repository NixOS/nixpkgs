{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "influxdb";
  version = "13.1.7";
  zipHash = "sha256-66E6M2iGgjmXwM0je3LZSPJ5BEgmeBXIUp+p6RvODuQ=";
  meta = {
    description = "Support for InfluxDB data sources";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
  };
}
