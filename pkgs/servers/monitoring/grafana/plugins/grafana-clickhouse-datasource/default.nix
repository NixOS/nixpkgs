{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "3.3.0";
  zipHash = {
    x86_64-linux = "sha256-FkOX/2vPmLtxe/oOISldlVhayy7AwfFxLeiwJ5TNgYY=";
    aarch64-linux = "sha256-4rCj+NaKPZbuVohlKmSf1M6n5ng9HZMrwzBCgLPdiok=";
    x86_64-darwin = "sha256-bpey6EwwAqXgxjvjJ6ou4rinidHCpUr+Z89YpAZK7z8=";
    aarch64-darwin = "sha256-u/U2lu4szf9JFt/zfhGmWKH2OUqpJDNaSI69EDdi1+w=";
  };
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody yuka ];
    platforms = attrNames zipHash;
  };
}
