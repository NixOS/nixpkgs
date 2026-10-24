{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "3.0.0";
  zipHash = "sha256-nPTZknC5rixs2Ssxy6Y4p3iRzx3E6vBrIwE1+R/YD3U=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
