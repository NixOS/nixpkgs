{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-discourse-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Allows users to search and view topics, posts, users, tags, categories, and reports on a given Discourse forum through Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
