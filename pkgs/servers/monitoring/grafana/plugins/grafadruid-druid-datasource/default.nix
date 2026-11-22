{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafadruid-druid-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Connects Grafana to Druid";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nukaduka ];
  };
}
