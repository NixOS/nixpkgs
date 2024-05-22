{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.0.2";
  zipHash = {
    x86_64-linux = "sha256-Orz+VQSUqxjJNOiKXYJDp9dKU1V5esNdx7q+/6NeHJI=";
    aarch64-linux = "sha256-D1rRuPqCXURrCMz2n4ZrKqdnyrwu+kRHF+KD3wMkghw=";
    x86_64-darwin = "sha256-h1hATVZfU7PGoOYVkYHAJEff8w9zRxFQS8vcaxlXsy0=";
    aarch64-darwin = "sha256-drEPwToa4q1FHBr9yRY8rqjMQXLsrQ1npXAXKqPd6bc=";
  };
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody ];
    platforms = attrNames zipHash;
  };
}
