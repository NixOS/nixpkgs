{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kapp }:

buildGoModule rec {
  pname = "kapp";
  version = "0.54.1";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "sha256-q9Am9ryrvmvuUCmHNCsf1iZz0wdaO87C1Gbvi40cKIA=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kapp" ];

  ldflags = [
    "-X github.com/vmware-tanzu/carvel-kapp/pkg/kapp/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kapp completion $shell > kapp.$shell
      installShellCompletion kapp.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kapp;
  };

  meta = with lib; {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://get-kapp.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
