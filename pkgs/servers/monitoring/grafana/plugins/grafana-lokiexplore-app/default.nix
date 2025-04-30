{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.13";
  zipHash = "sha256-oTiwvkKiKpeI7MUxyaRuxXot4UhMeSvuJh0N1VIfA5Q=";
  meta = with lib; {
    description = "The Grafana Logs Drilldown app offers a queryless experience for browsing Loki logs without the need for writing complex queries.";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
