{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.23";
  zipHash = "sha256-N2YIZXqHR7/f2W3FI1Jhjf940Mq5xs0zuXCgrYPa3Fo=";
  meta = {
    description = "Browse Loki logs without the need for writing complex queries";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = lib.platforms.unix;
  };
}
