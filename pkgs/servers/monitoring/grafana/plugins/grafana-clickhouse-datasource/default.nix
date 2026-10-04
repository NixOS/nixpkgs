{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.22.0";
  zipHash = {
    x86_64-linux = "sha256-IEH0wyFgru3DbG5RzJllQrRMJ/RZXdM1RssYAYswuNg=";
    aarch64-linux = "sha256-UwvvH/WSpao/9D45Hnpm2N+HXJQNBR2k/jDdrA5UBUM=";
    aarch64-darwin = "sha256-7W7otSZlBdnwqzHFKgcH2PRRixYSwgazY3PSl606yFU=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
