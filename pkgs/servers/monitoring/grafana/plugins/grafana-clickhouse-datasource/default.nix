{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clickhouse-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
  };
}
