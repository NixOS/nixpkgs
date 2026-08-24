{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "2.5.1";
  zipHash = "sha256-EyqM+XrmRnoI80t8d2AmUuCX/eAOOek+yU0GCwOWQno=";
  meta = {
    description = "Browse Loki logs without the need for writing complex queries";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
