{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "3.8.2";
  zipHash = "sha256-TJMKHB1loDiBrTWKpIUNfcMTBXhorxqvLrdBEuUspto=";
<<<<<<< HEAD
  meta = {
    description = "Use a SQLite database as a data source in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Use a SQLite database as a data source in Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
