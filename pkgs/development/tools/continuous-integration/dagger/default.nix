{ lib, buildGoModule, fetchFromGitHub, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-67ILrOVG31LrLgMcT+bZyWQ3lSahWOdWRyWpgUYSr4I=";
  };

  vendorHash = "sha256-bidJ7V/+yU3pBVXMdD4S0QVh9gKcvRN46Ut5OdSrnNc=";
  proxyVendor = true;

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

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
