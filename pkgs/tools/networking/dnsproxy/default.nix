{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.70.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    rev = "v${version}";
    hash = "sha256-kXIUcTT3LGhKeUVlq/hDvO6/y/mQNIFBhJLSe1F89EI=";
  };

  vendorHash = "sha256-ECi6NciA5oyUyVaVlON4mAPKoWQSDvgV0uwk5MGYjy4=";

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
