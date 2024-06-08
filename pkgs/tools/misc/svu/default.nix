{ lib, buildGoModule, fetchFromGitHub, testers, svu }:

buildGoModule rec {
  pname = "svu";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-10pDJQ5GQrrNJaDD2PP9MQqib4llsA5c6X3Qeu3Lgkk=";
  };

  vendorHash = "sha256-/FSvNoVDWAkQs09gMrqyoA0su52nlk/nSCYRAhQhbwQ=";

  ldflags = [ "-s" "-w" "-X=main.version=${version}" "-X=main.builtBy=nixpkgs" ];

  # test assumes source directory to be a git repository
  postPatch = ''
    rm internal/git/git_test.go
  '';

  passthru.tests.version = testers.testVersion { package = svu; };

  meta = with lib; {
    description = "Semantic Version Util";
    homepage = "https://github.com/caarlos0/svu";
    maintainers = with maintainers; [ caarlos0 ];
    license = licenses.mit;
    mainProgram = "svu";
  };
}
