{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "redis-datasource";
  version = "2.2.0";
  zipHash = "sha256-a4at8o185XSOyNxZZKfb0/j1CVoKQ9JZx0ofoPUBqKs=";
  meta = with lib; {
    description = "Redis Data Source for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
