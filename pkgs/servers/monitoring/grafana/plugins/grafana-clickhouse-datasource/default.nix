{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.15.0";
  zipHash = {
    x86_64-linux = "sha256-JS03BOFOVsIK1mKetA8FVkKsq3wffuZbsG4ugE92NS8=";
    aarch64-linux = "sha256-T7e/y6qX+xIcYFoNPW61UnZ56i829NtJiFpZZTJrMi8=";
    x86_64-darwin = "sha256-dhGQadp79cjvSFbiVx7r9NpCH6iCUoDKcSrJ2zkkRYs=";
    aarch64-darwin = "sha256-GgfDiVqpv/EUKGZFcXByZC6EZJN+TYIDaOHszH5kl/I=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
