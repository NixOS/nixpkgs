{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-json-datasource";
  version = "1.3.25";
  zipHash = "sha256-6F6ECRZT8l3sWXn5KEcT2QRIIi3o8AULbV4InFm1hTo=";
  meta = {
    description = "Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
