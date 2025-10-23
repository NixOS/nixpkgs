{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "3.8.2";
  zipHash = "sha256-TJMKHB1loDiBrTWKpIUNfcMTBXhorxqvLrdBEuUspto=";
  meta = with lib; {
    description = "Use a SQLite database as a data source in Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
