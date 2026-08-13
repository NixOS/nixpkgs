{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "2.1.0";
  zipHash = "sha256-RKcA+boUtcyLlimXOPPkskR38KgN1LcT6tXG5iF61jI=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
