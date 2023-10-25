{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "redis-datasource";
  version = "2.1.1";
  zipHash = "sha256-Qhdh2UYOq/El08jTheKRa3f971QKeVmMWiA6rnXNUi4=";
  meta = with lib; {
    description = "Redis Data Source for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
