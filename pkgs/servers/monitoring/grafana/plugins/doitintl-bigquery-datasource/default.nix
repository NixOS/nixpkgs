{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "doitintl-bigquery-datasource";
  version = "2.0.3";
  zipHash = "sha256-QxUNRsO1ony+6tVdpwx3P/63XNIdAVIren6hUwChf9E=";
  meta = {
    description = "BigQuery DataSource for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jwygoda ];
    platforms = lib.platforms.unix;
  };
}
