{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.17.4";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DF9Bx6CzZLdnyqe8PNWU2I9ym2SBDAjdwG9/zxvSjgs=";
  };

  vendorHash = "sha256-tX/QpAZLuQEYhm1I1twlg3TefaLqfiEz9cXID+r6EHA=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
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
