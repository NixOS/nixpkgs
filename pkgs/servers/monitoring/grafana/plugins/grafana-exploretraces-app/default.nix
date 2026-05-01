{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "2.0.2";
  zipHash = "sha256-e179Vm7RwSHWrUZuvhHOPWtFuGJkVM22GzPN/WenR/Q=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
