{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.26";
  zipHash = "sha256-7EztpeZIpDu/ner9EOiOjoh3J/GBgYWpZoh3usXyPqo=";
  meta = with lib; {
    description = "Browse Loki logs without the need for writing complex queries";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
