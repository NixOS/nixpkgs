{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "2.0.4";
  zipHash = "sha256-pNmHq7kRlpucwd2taNaPa/m3+yBPUJwBLFoWpxe8eVQ=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
