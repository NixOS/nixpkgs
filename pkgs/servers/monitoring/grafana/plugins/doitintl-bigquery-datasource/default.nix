{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "doitintl-bigquery-datasource";
  version = "2.0.1";
  zipHash = "sha256-tZyvER/rxL+mo2tgxFvwSIAmjFm/AnZ0RgvmD1YAE2U=";
  meta = with lib; {
    description = "BigQuery DataSource for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ jwygoda ];
    platforms = platforms.unix;
  };
}
