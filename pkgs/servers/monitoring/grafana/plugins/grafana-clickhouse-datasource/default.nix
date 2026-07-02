{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.16.0";
  zipHash = {
    x86_64-linux = "sha256-fmYrMoLMFSA/bG7db7IhEKcgYAd3ukRTZOtT6h0bCbw=";
    aarch64-linux = "sha256-TTo85HkQrq6bbifAfG30BPVP72nqOYP9yaJ7INpBN1U=";
    x86_64-darwin = "sha256-Evu/YUQS62y7E/efJeQOJEgsbL0212Bl1aFl4SzMUqM=";
    aarch64-darwin = "sha256-NC5yVkrnD1J1LiDbSnKwNZsUOCShgfSZy8FuDnXpZWs=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
