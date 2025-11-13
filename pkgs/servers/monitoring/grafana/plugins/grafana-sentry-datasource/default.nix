{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-sentry-datasource";
  version = "2.2.3";
  zipHash = "sha256-y0gI1gSBgzXbbTDdaBIsvPeNvah8ThtU42GmL3LYsd4=";
  meta = {
    description = "Integrate Sentry data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
    platforms = lib.platforms.unix;
  };
}
