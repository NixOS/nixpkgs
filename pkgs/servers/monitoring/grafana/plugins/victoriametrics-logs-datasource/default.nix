{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.19.2";
  zipHash = "sha256-+mGW9A39GioPKW5j2vT2aNKrBc/A6qsaeIjo4EUrXs4=";
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.unix;
  };
}
