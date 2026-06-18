{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  version = "6.2.3";
  zipHash = "sha256-Z2R/kl6y4OaN8JRqPaKOuVLRZvPy2M43wVE+al4YquI=";
  meta = {
    description = "Dynamic, data-driven text panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.unix;
  };
}
