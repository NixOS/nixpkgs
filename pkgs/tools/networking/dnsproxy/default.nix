{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.35.5";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DScN/swigecdhucxhfP1mNr2mDX6HbY2dktkN8BxBjI=";
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
