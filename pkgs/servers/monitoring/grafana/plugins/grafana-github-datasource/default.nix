{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
