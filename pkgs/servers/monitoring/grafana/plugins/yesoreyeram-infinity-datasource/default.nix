{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "yesoreyeram-infinity-datasource";
  version = "2.0.0";
  zipHash = "sha256-IL1XZcinX1er4kqpQYP0oV0SDXO6o0us1i3NY9ANDLk=";
  meta = with lib; {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
    platforms = platforms.unix;
  };
}
