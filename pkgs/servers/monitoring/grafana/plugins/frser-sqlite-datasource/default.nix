{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "frser-sqlite-datasource";
  version = "3.5.0";
  zipHash = "sha256-BwAurFpMyyR318HMzVXCnOEQWM8W2vPPisXhhklFLBY=";
  meta = with lib; {
    description = "This is a Grafana backend plugin to allow using an SQLite database as a data source. The SQLite database needs to be accessible to the filesystem of the device where Grafana itself is running.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
