{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.3.5";
  zipHash = {
    x86_64-linux = "sha256-gYDE8TP6KNB0QKiSmTz7DUKfFcA/PUWLD3O83mh5sYA=";
    aarch64-linux = "sha256-TjpsTOX01vLMO7BAVDis4MD0uTFT2ntSC6YiMNGpe2w=";
    aarch64-darwin = "sha256-9a0R7roTgylxLJZAlNV4BNQTf81/Tk5L5dL4zEvG3s0=";
  };
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
