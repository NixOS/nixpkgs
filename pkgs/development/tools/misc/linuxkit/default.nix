{ lib, buildGoModule, fetchFromGitHub, git, testers, linuxkit }:

buildGoModule rec {
  pname = "linuxkit";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "sha256-kmsc3CyeCE61fLEpKMTN09WTVo+By6ZrtO89eyBqZ34=";
  };

  vendorSha256 = null;

  modRoot = "./src/cmd/linuxkit";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linuxkit/linuxkit/src/cmd/linuxkit/version.Version=${version}"
  ];

  checkInputs = [ git ];

  passthru.tests.version = testers.testVersion {
    package = linuxkit;
    command = "linuxkit version";
  };

  meta = with lib; {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = licenses.asl20;
    homepage = "https://github.com/linuxkit/linuxkit";
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.unix;
  };
}
