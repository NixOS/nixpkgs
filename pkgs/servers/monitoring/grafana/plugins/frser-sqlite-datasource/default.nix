{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "3.8.0";
  zipHash = "sha256-wk0zEGQjDdz8bIc7e5aiaqg7AaTS6u8zp+WJy5YlWlQ=";
  meta = {
    description = "Use a SQLite database as a data source in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
