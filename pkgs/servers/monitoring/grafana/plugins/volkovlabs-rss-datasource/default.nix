{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-rss-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Plugin for Grafana that retrieves RSS/Atom feeds and allows visualizing them using Dynamic Text and other panels";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
