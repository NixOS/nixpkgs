{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.21.3";
  zipHash = {
    x86_64-linux = "sha256-U8BgIhTnyhrxczlid5KTWHOGsLmoxUTs6tgLgZ5fVgs=";
    aarch64-linux = "sha256-2leNWPL7G+Vfq1L4pOuXuaX2p9GIcGabowU3MhpT9Dw=";
    aarch64-darwin = "sha256-lrsGvghy9NviWRswn7i4GQ2KSJz3Tz5/VuGPRvjKPis=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
