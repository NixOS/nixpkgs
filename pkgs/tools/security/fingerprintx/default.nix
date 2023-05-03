{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fingerprintx";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "fingerprintx";
    rev = "refs/tags/v${version}";
    hash = "sha256-CzKaMRPs31Pt/vyLoQ4GrUP31s6zpnEk/p7x3FS4AAg=";
  };

  vendorHash = "sha256-wpqn2Gq/sGBBVIJRiwGc+6fnNJuKRlokb94bKH03oKc=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Standalone utility for service discovery on open ports";
    homepage = "https://github.com/praetorian-inc/fingerprintx";
    changelog = "https://github.com/praetorian-inc/fingerprintx/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
