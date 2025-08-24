{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  version = "3.4.1";
  zipHash = "sha256-qXgauKqiZHzS2az8uYiGjEFev0gS4i0yH8cowC/EZ14=";
  meta = with lib; {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
