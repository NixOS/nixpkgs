{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.46.3";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7Sp46Rk99P/QgkL4ge9wCHIJ4MUqDo9f/uGA0xKlyaw=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" "-X" "main.VersionString=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ contrun ];
  };
}
