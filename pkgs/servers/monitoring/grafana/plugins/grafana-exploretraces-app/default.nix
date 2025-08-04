{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.1.2";
  zipHash = "sha256-eLSC+K1+JqSOo0HgFCTZ8pYevtO3s/ZhkJBlr29GGdY=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = lib.platforms.unix;
  };
}
