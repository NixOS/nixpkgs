{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.10";
  zipHash = "sha256-1+5xil0XmcLCDKpObuxpnoMnQZaT1I62zL6xatlyKc4=";
  meta = with lib; {
    description = "The Grafana Logs Drilldown app offers a queryless experience for browsing Loki logs without the need for writing complex queries.";
    license = licenses.agpl3Only;
    maintainers = lib.teams.fslabs.members;
    platforms = platforms.unix;
  };
}
