{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "frser-sqlite-datasource";
  version = "3.8.0";
  zipHash = "sha256-wk0zEGQjDdz8bIc7e5aiaqg7AaTS6u8zp+WJy5YlWlQ=";
  meta = with lib; {
    description = "Use a SQLite database as a data source in Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
