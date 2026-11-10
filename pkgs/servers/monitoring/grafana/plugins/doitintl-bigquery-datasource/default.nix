{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "doitintl-bigquery-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "BigQuery DataSource for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jwygoda ];
  };
}
