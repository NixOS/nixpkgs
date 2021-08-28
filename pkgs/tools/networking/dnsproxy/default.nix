{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.37.4";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EV/+m7Uzf7s6+J0jdsim3UP84iK/tXlPNfkyrtrx5NQ=";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
  };
}
