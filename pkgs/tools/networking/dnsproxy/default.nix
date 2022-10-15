{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.45.3";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0yb+YfX8+QKH+Mi0D1Gh0b1hfh2EiemMTkotV+z53Ns=";
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
