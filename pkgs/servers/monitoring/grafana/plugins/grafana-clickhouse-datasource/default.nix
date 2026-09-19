{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.21.2";
  zipHash = {
    x86_64-linux = "sha256-NGPQNafd3vhl4+1rw7rqPFtPulL+EXOlKFNau1hAzWM=";
    aarch64-linux = "sha256-jwhH1aKc3fPC5qup5hqm8nzXNU5zbwqMZQOwBAqE6R8=";
    aarch64-darwin = "sha256-5pUXnUuCwt2uHu3LDoJuupB/0PssEbRZkF62kY7OcgQ=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
