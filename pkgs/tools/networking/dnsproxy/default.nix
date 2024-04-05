{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    rev = "v${version}";
    hash = "sha256-CqEvGE1MSll+khEFvH8Y0q4XyxbTjwNRr9h9FKf5Kfs=";
  };

  vendorHash = "sha256-AZQl70NJwE6lVMO/G1RG1NIfXK1SbYWh4/wAIi4Ac5o=";

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
