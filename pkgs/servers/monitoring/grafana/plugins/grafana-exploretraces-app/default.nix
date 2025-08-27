{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.1.3";
  zipHash = "sha256-0i9ndLOUXisJJk2sV0Xt0NC8KNn2k5/cIRS/G0jS8Ks=";
  meta = with lib; {
    description = "Opinionated traces app";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
