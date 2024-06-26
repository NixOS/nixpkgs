{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "slsa-verifier";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
    hash = "sha256-vDzgbE/Cl3TMVzf6H300EtDpGPYBkkSOJBu+0l2fPFw=";
  };

  vendorHash = "sha256-NkEYr56Wb3EV7TI+0W7w7PdmbZpX3/yQ4TbOebqW9ng=";

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
    maintainers = with lib.maintainers; [
      developer-guy
      mlieberman85
    ];
  };
}
