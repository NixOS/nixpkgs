{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "slsa-verifier";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
    hash = "sha256-x9phhfQVeUO7NRjB6n1rdwkpeCu4VMUcJTrkP6PfVyA=";
  };

  vendorHash = "sha256-HJ3/RY0Co86y1t2Mas5C+rjwRRG4ZJgxjkz9iWcKf5E=";

  CGO_ENABLED = 0;

  subPackages = [ "cli/slsa-verifier" ];

  tags = [ "netgo" ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/slsa-framework/slsa-verifier";
    changelog = "https://github.com/slsa-framework/slsa-verifier/releases/tag/v${version}";
    description = "Verify provenance from SLSA compliant builders";
    mainProgram = "slsa-verifier";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy mlieberman85 ];
  };
}
