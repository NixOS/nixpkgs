{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  version = "6.3.0";
  zipHash = "sha256-nobTHc/GucfwyDGMsxPpDim9txzfygi1UFjd6XR+nLc=";
  meta = {
    description = "Dynamic, data-driven text panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.unix;
  };
}
