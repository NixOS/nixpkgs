{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-sentry-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Integrate Sentry data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
  };
}
