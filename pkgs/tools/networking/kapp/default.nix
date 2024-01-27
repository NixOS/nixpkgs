{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kapp }:

buildGoModule rec {
  pname = "kapp";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kapp";
    rev = "v${version}";
    sha256 = "sha256-o1MFbyjgOvhgcrlkbYGn0+nHENL2STFiD9CUkCdB56E=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kapp" ];

  CGO_ENABLED = 0;

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
    homepage = "https://carvel.dev/kapp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
