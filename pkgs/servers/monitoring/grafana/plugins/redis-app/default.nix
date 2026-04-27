{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-app";
  version = "2.3.2";
  zipHash = "sha256-HncZBj0FCku7DRTCDigY2aH2oBScDg7d9XL7ixm7DOM=";
  meta = {
    description = "Redis Application plugin for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
  };
}
