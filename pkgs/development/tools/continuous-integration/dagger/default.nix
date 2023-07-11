{ lib, buildGoModule, fetchFromGitHub, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-9Mv+We4VtsnnZJJF5P3+1EhrX6QrcV7hEzYaLqai5IU=";
  };

  vendorHash = "sha256-ptfrcsE3YQBqChxbOjkO3xia6ZTI0fGJNXA+q32m9wY=";
  proxyVendor = true;

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X=github.com/dagger/dagger/internal/engine.Version=${version}" ];

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
