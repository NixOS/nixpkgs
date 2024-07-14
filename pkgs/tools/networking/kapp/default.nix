{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kapp }:

buildGoModule rec {
  pname = "kapp";
  version = "0.63.1";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kapp";
    rev = "v${version}";
    hash = "sha256-6i09V4Y2rFoChXo5roxVUFf84qCu2X9i5NtlYtw4RhE=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kapp" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-X carvel.dev/kapp/pkg/kapp/version.Version=${version}"
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
    mainProgram = "kapp";
  };
}
