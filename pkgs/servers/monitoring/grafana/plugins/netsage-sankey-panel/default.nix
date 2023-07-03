{ lib, grafanaPlugin }:

grafanaPlugin rec {
  pname = "netsage-sankey-panel";
  version = "1.1.1";
  zipHash = "sha256-WmXcIsV6jP2Z53qbqsEAElQI+VzoJFaVU8ib91+ZYM8=";
  meta = with lib; {
    homepage = "https://github.com/netsage-project/netsage-sankey-panel/";
    changelog = "https://github.com/netsage-project/netsage-sankey-panel/releases/tag/v${version}";
    description = "Panel plugin for generating Sankey diagrams in Grafana 7.0+";
    license = licenses.asl20;
    maintainers = teams.wdz.members;
    platforms = platforms.unix;
  };
}
