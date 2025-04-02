{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
  version = "0.15.0";
  zipHash = "sha256-cNbCmQPTuVfxc/Y60YSyoOXGPJteiK4f+9UDAd6n3PM=";
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.unix;
  };
}
