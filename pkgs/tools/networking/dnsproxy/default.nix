{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.50.1";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lDHfVhhc2fD8a1kTpX74RNogKC6ov1RKvzmjgvu+MNQ=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" "-X" "main.VersionString=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ contrun ];
  };
}
