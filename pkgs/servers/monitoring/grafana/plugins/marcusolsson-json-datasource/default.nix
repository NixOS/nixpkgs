{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-json-datasource";
  version = "1.4.0";
  zipHash = "sha256-DkBZzzLaFfQuiFoElzluUJMXgUx0ZAdTsf6K1/Cv16w=";
  meta = {
    description = "Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
