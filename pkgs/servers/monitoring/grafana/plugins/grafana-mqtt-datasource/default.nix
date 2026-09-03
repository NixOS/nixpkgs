{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.3.6";
  zipHash = {
    x86_64-linux = "sha256-q6o+NfRqncZYCmtPSvnMxMwKPOmdkj3zWem108kLyF4=";
    aarch64-linux = "sha256-ej1/EGDLdlyhyVIoEMrJSsn4h0c+DrRfYUM9Y7MrpWc=";
    aarch64-darwin = "sha256-6UWLNK9dTOh+x8mQxwlDFwS6L5R74Lpspdl7U1uiuYA=";
  };
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
