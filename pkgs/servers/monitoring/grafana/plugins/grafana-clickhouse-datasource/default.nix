{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clickhouse-datasource";
  version = "4.11.2";
  zipHash = "sha256-VW/d9tcLGbqkTL4rbZnnLGOaSfsyqqy9nBKnaf/FW7U=";
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody ];
    platforms = platforms.unix;
  };
}
