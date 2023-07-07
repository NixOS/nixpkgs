{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-82RBNMCcEe2gB1Ygbm1S6UgMPUQ+Lm37zc1JM3Ca/gg=";
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
