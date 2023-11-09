{ lib, buildGoModule, fetchFromGitHub, testers, notation }:

buildGoModule rec {
  pname = "notation";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KcB5l6TRZhciXO04mz5iORR4//cAhrh+o4Kdq7LA4A4=";
  };

  vendorHash = "sha256-r58ZV63KIHKxh5HDeQRfd0OF0s7xpC4sXvsYLhm8AIE=";

  # This is a Go sub-module and cannot be built directly (e2e tests).
  excludedPackages = [ "./test" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/notaryproject/notation/internal/version.Version=${version}"
    "-X github.com/notaryproject/notation/internal/version.BuildMetadata="
  ];

  passthru.tests.version = testers.testVersion {
    package = notation;
    command = "notation version";
  };

  meta = with lib; {
    description = "CLI tool to sign and verify OCI artifacts and container images";
    homepage = "https://notaryproject.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
