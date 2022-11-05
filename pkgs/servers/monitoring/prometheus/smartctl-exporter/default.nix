{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z8z/A3BmaOSlS6/V0bEyVaUwV96pa7HM/0jad81394Q=";
  };

  vendorSha256 = "sha256-n60NevHgET+wPet3w1BXo5mX25/SCtpsU3JaG2HrKjs=";

  meta = with lib; {
    description = "Export smartctl statistics for Prometheus";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ hexa ];
  };
}
