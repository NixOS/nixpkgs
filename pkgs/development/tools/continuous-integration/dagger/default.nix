{ lib, buildGoModule, fetchFromGitHub, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-d7Yz5MgV5l54uGbQPmGUVZuz4xdGO+gSiI9/6Axqsb0=";
  };

  vendorHash = "sha256-fRHs2B/pea9FIqPpOaR6z3do+tpnaGlKTbwfF/smC4w=";
  proxyVendor = true;

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X github.com/dagger/dagger/internal/engine.Version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = dagger;
    command = "dagger version";
  };

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche sagikazarmark ];
  };
}
