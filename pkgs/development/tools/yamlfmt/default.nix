{ lib, buildGoModule, fetchFromGitHub, testers, yamlfmt }:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B1bRYG7ldewdyK8K2Yy5liQcEqv/3/67cQD8JKp8vQI=";
  };

  vendorHash = "sha256-UfULQw7wAEJjTFp6+ACF5Ki04eFKeUEgmbt1c8pUolA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  passthru.tests.version = testers.testVersion {
    package = yamlfmt;
  };

  meta = with lib; {
    description = "Extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "yamlfmt";
  };
}
