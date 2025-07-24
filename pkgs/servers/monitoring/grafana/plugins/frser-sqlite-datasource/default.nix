{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "3.5.0";
  zipHash = "sha256-BwAurFpMyyR318HMzVXCnOEQWM8W2vPPisXhhklFLBY=";
  meta = with lib; {
    description = "Use a SQLite database as a data source in Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
