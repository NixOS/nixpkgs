{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  version = "3.7.1";
  zipHash = "sha256-jXK5Rw6IpX1ZCc1TZ0oU9RbmwDM2lxAxbfHIq00WZhU=";
  meta = {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
