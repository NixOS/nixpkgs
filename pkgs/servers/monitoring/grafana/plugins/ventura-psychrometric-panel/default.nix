{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "ventura-psychrometric-panel";
  version = "4.5.1";
  zipHash = "sha256-Y/Eh3eWZkPS8Q1eha7sEJ3wTMI7QxOr7MEbPc25fnGg=";
  meta = with lib; {
    description = "Grafana plugin to display air conditions on a psychrometric chart.";
    license = licenses.bsd3 // {
      spdxId = "BSD-3-Clause-LBNL";
      url = "https://spdx.org/licenses/BSD-3-Clause-LBNL.html";
      fullName = "Lawrence Berkeley National Labs BSD variant license";
      shortName = "lbnl-bsd3";
    };
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
