{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.22.1";
  zipHash = {
    x86_64-linux = "sha256-/ItKT/cefbYUo1YOW1Z4u6tSNXiryigKGV4L0w2aUtU=";
    aarch64-linux = "sha256-yRQGV99ch9FzbO5SLdTyEzlROPqIyEVZZgN287YJqKU=";
    aarch64-darwin = "sha256-le/g8ywtx47SnGPMN8f744zXolue/Wa+a4JJfDwMw38=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
