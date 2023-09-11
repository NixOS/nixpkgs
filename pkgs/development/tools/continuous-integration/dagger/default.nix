{ lib, buildGoModule, fetchFromGitHub, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-iFuPbSat555QHPqqP6j/6uTid19x1+OtRHADmGxTYzs=";
  };

  vendorHash = "sha256-DWmHq8BIR00QTh3ZcbEgTtbHwTmsMFAhV7kQVRSKNdQ=";
  proxyVendor = true;

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X github.com/dagger/dagger/engine.Version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = dagger;
    command = "dagger version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche sagikazarmark ];
  };
}
