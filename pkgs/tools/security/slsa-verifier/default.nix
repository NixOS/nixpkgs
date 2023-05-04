{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "slsa-verifier";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
    hash = "sha256-5TILEYrnXNDxtRkCaFHUYAI0w5KSzlUAKovTnJcll90=";
  };

  vendorHash = "sha256-xpYXA/j/ClcJl80yh/tbG5jIfL7jdmG+k95Lipr2+RA=";

  CGO_ENABLED = 0;
  GO111MODULE = "on";
  GOFLAGS = "-trimpath";

  subPackages = [ "cli/slsa-verifier" ];

  tags = [ "netgo" ];

  ldflags = [
    "-s"
    "-w"
    "-buildid="
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/slsa-framework/slsa-verifier";
    changelog = "https://github.com/slsa-framework/slsa-verifier/releases/tag/v${version}";
    description = "Verify provenance from SLSA compliant builders";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy mlieberman85 ];
  };
}
