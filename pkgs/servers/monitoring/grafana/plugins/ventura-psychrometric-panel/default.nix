{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "ventura-psychrometric-panel";
  version = "4.0.6";
  zipHash = "sha256-SOJT1ezDLqz3FFPxlsagTXAu0b2yEnEoyR4+XAO0pLI=";
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
