{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.12.3";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H6JGeLE/fzbfo8/mn5hTKcr7XfvmjOojeXLxUKGzt4w=";
  };

  vendorHash = "sha256-Pwtvv/qVX91yWx49IYdveVCySoVxekvHomfAzOdFj7w=";

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
