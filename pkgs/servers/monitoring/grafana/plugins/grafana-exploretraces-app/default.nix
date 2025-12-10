{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.2.2";
  zipHash = "sha256-vQSnjSPiYvgwpbO7VvmG77DfP85+R6fRoGGpr+xslTc=";
  meta = with lib; {
    description = "Opinionated traces app";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
