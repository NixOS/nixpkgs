{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "slsa-verifier";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
    hash = "sha256-swyBDJTv6Sp65Q46QGm/N/kIfGfln+vBTYXVOI9CAOE=";
  };

  vendorHash = "sha256-rCGj2o59US2t/ckqXirEDgYn9dGvVSzMVcFEZosasBc=";

  CGO_ENABLED = 0;
  GO111MODULE = "on";
  GOFLAGS = "-trimpath";

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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy mlieberman85 ];
  };
}
