{ lib, buildGoModule, fetchFromGitHub, testers, notation }:

buildGoModule rec {
  pname = "notation";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mj+LCO6Q4kKfYewPl0R9axZB9O4Yy+GkLlUIDe6yhlI=";
  };

  vendorHash = "sha256-wQTRgOSOq0LeiSwF5eowaW4R2xCx+kEb0WQ+upsxdAA=";

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
