{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.65.2";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    rev = "v${version}";
    hash = "sha256-+82dYFk5mN1p17++2Yg3GCLe8Ud4KbZIGgdfaTepEBw=";
  };

  vendorHash = "sha256-kBf32hXZ5fpu2ME30t5FmYwGMnD6Jp6owGnjUL9CViY=";

  ldflags = [ "-s" "-w" "-X" "github.com/AdguardTeam/dnsproxy/internal/version.version=${version}" ];

  # Development tool dependencies; not part of the main project
  excludedPackages = [ "internal/tools" ];

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ contrun diogotcorreia ];
    mainProgram = "dnsproxy";
  };
}
