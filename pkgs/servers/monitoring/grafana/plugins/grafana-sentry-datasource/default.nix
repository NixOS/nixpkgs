{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-sentry-datasource";
  version = "2.2.4";
  zipHash = "sha256-+krWZdyD0yjzbNFV4KMSnSLb1/txwbB8dWSfO6IOc0I=";
  meta = {
    description = "Integrate Sentry data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
    platforms = lib.platforms.unix;
  };
}
