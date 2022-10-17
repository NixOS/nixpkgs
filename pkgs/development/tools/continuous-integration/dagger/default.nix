{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dagger";
  version = "0.2.36";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    sha256 = "sha256-U+MdX/7RIrhnPjUjzYAQEVeHQUpgMtKanvjPLBjCNSY=";
  };

  vendorSha256 = "sha256-ArdqEHECnGTMs3sJrPIAfmTT0D2V8SHyTYXmDODVtuo=";

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X go.dagger.io/dagger/version.Version=${version}" ];

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche sagikazarmark ];
  };
}
