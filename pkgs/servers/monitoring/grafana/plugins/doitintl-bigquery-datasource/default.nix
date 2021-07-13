{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "doitintl-bigquery-datasource";
  version = "2.0.2";
  zipHash = "sha256-GE6DNuQ5WtS/2VmXbQBeRdVKDbLlLirWXW51i0RF6Cc=";
  meta = with lib; {
    description = "BigQuery DataSource for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ jwygoda ];
    platforms = platforms.unix;
  };
}
