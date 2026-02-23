{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-json-datasource";
  version = "1.3.27";
  zipHash = "sha256-/v7t54qofPxUytNvrH9S2vCswjgB+5raBCoqycxzPJM=";
  meta = {
    description = "Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
