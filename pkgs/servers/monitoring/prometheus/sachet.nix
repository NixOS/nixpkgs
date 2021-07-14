{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sachet";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "messagebird";
    repo = pname;
    rev = version;
    sha256 = "10dxlw0n2b742xsdg1sc8wxy4bjscs897lwfkdzxw18csqm1hffi";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Sachet is an SMS alerting tool for the Prometheus Alertmanager.";
    homepage = "https://github.com/messagebird/sachet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ govanify ];
  };
}
