{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.1.1";
  zipHash = "sha256-vzLZvBxFF9TQBWvuAUrfWROIerOqPPjs/OKUyX1dBac=";
  meta = with lib; {
    description = "Opinionated traces app";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
