{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.10.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+bMxZ/ga3LLlZmjfysP/FXiLFokAyagkmds/js3HCzs=";
  };

  vendorHash = "sha256-Rf1HY2Q0t3iOuopnPRCkDKauWLFy9qhRh94QiwbDuOQ=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
  };

  passthru.tests.lego = nixosTests.acme;
}
