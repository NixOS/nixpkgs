{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  version = "5.7.0";
  zipHash = "sha256-HYmSj3DUdDM5m+D/nXNGmP2YpsljS895kOl+Ki1Zz88=";
  meta = with lib; {
    description = "Dynamic, data-driven text panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.unix;
  };
}
