{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "doitintl-bigquery-datasource";
  version = "2.0.3";
  zipHash = "sha256-QxUNRsO1ony+6tVdpwx3P/63XNIdAVIren6hUwChf9E=";
<<<<<<< HEAD
  meta = {
    description = "BigQuery DataSource for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jwygoda ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "BigQuery DataSource for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ jwygoda ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
