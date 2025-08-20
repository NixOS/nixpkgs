{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "fetzerch-sunandmoon-datasource";
  version = "0.3.3";
  zipHash = "sha256-IJe1OiPt9MxqqPymuH0K27jToSb92M0P4XGZXvk0paE=";
  meta = with lib; {
    description = "SunAndMoon is a Datasource Plugin for Grafana that calculates the position of Sun and Moon as well as the Moon illumination using SunCalc.";
    license = licenses.mit;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
