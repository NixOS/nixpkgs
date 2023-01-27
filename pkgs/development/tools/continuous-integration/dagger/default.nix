{ lib, buildGoModule, fetchFromGitHub, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-/JbKnDjC3C0mF4WHOmmvblrr/e1MhOws3Q/oXZCgdEM=";
  };

  vendorHash = "sha256-wufztmiOwgY0Q6x9oMrJo28JGx8iprC1gr9zZjSWwuw=";
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
