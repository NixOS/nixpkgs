{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j5TboKYv4xycpCXnuFP/37ioiS89G7eeViEmGwB2BUY=";
  };

  vendorHash = "sha256-uniml5D8887cQyxxZIDhYLni/+r6ZtZ9nJBKPtNeDtI=";

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
    mainProgram = "lego";
  };

  passthru.tests.lego = nixosTests.acme;
}
