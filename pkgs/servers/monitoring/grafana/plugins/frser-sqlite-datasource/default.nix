{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "3.8.2";
  zipHash = "sha256-TJMKHB1loDiBrTWKpIUNfcMTBXhorxqvLrdBEuUspto=";
  meta = {
    description = "Use a SQLite database as a data source in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
