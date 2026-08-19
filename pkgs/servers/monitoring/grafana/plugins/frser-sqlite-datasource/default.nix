{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "4.0.6";
  zipHash = "sha256-5c4jVN0mupvqVrN/ntQFDMkXpGuFigoZHhyv2jgr8Yo=";
  meta = {
    description = "Use a SQLite database as a data source in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
