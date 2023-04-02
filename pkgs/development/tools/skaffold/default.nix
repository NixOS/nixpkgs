{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "skaffold";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "skaffold";
    rev = "v${version}";
    hash = "sha256-8w8Qt1WJUB566uXBDbkLsZekoOwmmd7iC/cSG+68dAU=";
  };

  vendorHash = "sha256-/3ThO/gsR5VfYsZYUk9oqTiLfnzCxzYEsZKd19fiLDk=";

  subPackages = ["cmd/skaffold"];

  ldflags = let t = "github.com/GoogleContainerTools/skaffold/v2/pkg/skaffold"; in [
    "-s" "-w"
    "-X ${t}/version.version=v${version}"
    "-X ${t}/version.gitCommit=${src.rev}"
    "-X ${t}/version.buildDate=unknown"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/skaffold version | grep ${version} > /dev/null
  '';

  postInstall = ''
    installShellCompletion --cmd skaffold \
      --bash <($out/bin/skaffold completion bash) \
      --zsh <($out/bin/skaffold completion zsh)
  '';

  meta = with lib; {
    homepage = "https://skaffold.dev/";
    changelog = "https://github.com/GoogleContainerTools/skaffold/releases/tag/v${version}";
    description = "Easy and Repeatable Kubernetes Development";
    longDescription = ''
      Skaffold is a command line tool that facilitates continuous development for Kubernetes applications.
      You can iterate on your application source code locally then deploy to local or remote Kubernetes clusters.
      Skaffold handles the workflow for building, pushing and deploying your application.
      It also provides building blocks and describe customizations for a CI/CD pipeline.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester bryanasdev000];
  };
}
