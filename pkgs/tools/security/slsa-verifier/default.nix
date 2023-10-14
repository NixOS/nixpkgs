{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "slsa-verifier";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
    hash = "sha256-2/4ExhMWXIKpkYQIodEsajA7q9zb4tOT9QUGunAutl0=";
  };

  vendorHash = "sha256-TwPbxoNu9PYAFEbUT5htyUY1RbkGow712ARJW6y496E=";

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
