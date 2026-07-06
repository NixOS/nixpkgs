{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-datasource";
  version = "2.2.0";
  zipHash = "sha256-a4at8o185XSOyNxZZKfb0/j1CVoKQ9JZx0ofoPUBqKs=";
  meta = {
    description = "Redis Data Source for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
  };
}
