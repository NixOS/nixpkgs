{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q+MLFdZTn14FhJ+gV3j5gVusL19lR7Cpd1BGxGvi848=";
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
