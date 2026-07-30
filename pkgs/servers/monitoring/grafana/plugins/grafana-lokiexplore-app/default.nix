{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "2.4.0";
  zipHash = "sha256-x+LxpkDN+iKW9QBDEg6oDURWuLUYNAC3UDWDmfoYcYo=";
  meta = {
    description = "Browse Loki logs without the need for writing complex queries";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
