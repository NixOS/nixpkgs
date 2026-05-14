{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "2.0.3";
  zipHash = "sha256-tV0XINCucQZeDirXHBJovA+V2MQ1f0gx3Jo9VsPNqSc=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
