{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "4.0.1";
  zipHash = "sha256-hjjhNZlez8SXvpy91D/mtJHavH8oiLKgt/4a2vnI4fU=";
  meta = {
    description = "Use a SQLite database as a data source in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
