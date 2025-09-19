{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.1.4";
  zipHash = "sha256-FIL+bFOFsqIml3/ywFZ2xwn3EDo9Ur8GHA5FEFQ2Kgs=";
  meta = with lib; {
    description = "Opinionated traces app";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
