{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "yesoreyeram-infinity-datasource";
  version = "3.5.0";
  zipHash = "sha256-+cUVv3D4PY5ZE3QjwXAiu7AwjYfOUidPRXsIwiwX5nc=";
  meta = with lib; {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
