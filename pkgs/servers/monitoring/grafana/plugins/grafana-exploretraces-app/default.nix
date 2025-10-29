{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.2.0";
  zipHash = "sha256-QXBOODMgFJvPLgr1Gr6mkpW2YJwYlDO/ZXL3BlEhEJ0=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = lib.platforms.unix;
  };
}
