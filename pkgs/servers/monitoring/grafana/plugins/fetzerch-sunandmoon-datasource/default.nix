{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "fetzerch-sunandmoon-datasource";
  version = "0.3.0";
  zipHash = "sha256-zvZ8h4lM3DGr11XV2nBxmY4f+OWwQgCNrLZXoqOTBFQ=";
  meta = with lib; {
    description = "SunAndMoon is a Datasource Plugin for Grafana that calculates the position of Sun and Moon as well as the Moon illumination using SunCalc.";
    license = licenses.mit;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
