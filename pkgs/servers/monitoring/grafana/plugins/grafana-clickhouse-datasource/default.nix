{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.23.2";
  zipHash = {
    x86_64-linux = "sha256-anRvTUmp6wG/qXmGQHsu6ms8o8OOyyYqP/om/rwu5FA=";
    aarch64-linux = "sha256-le0j/G8CMuJ1zw2wvKSUJ33ngzGSKoLkl1Gui7y88uc=";
    aarch64-darwin = "sha256-XgnzgjNJyZLHXIFKYVOi8joC6SVErLRe5BUKlramy2Q=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
