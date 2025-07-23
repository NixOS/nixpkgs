{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.1.2";
  zipHash = "sha256-eLSC+K1+JqSOo0HgFCTZ8pYevtO3s/ZhkJBlr29GGdY=";
  meta = with lib; {
    description = "Opinionated traces app";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
