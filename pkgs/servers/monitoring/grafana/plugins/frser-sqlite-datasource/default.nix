{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "4.0.2";
  zipHash = "sha256-soRmlYBhFhUoQmSGJC6mMP+UH7nqKzBTVItOk2WFggs=";
  meta = {
    description = "Use a SQLite database as a data source in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
