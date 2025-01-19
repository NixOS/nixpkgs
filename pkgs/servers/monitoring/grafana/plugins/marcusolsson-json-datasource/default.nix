{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-json-datasource";
  version = "1.3.17";
  zipHash = "sha256-L1G5s9fEEuvNs5AWXlT00f+dU2/2Rtjm4R3kpFc4NRg=";
  meta = {
    description = "The Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
