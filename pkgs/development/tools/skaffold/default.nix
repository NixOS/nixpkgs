{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "skaffold";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "skaffold";
    rev = "v${version}";
    sha256 = "sha256-j7e+zwt6CxYndwhv1CsUU0qcLkzyBts+k8K0/CqbktQ=";
  };

  vendorSha256 = "sha256-9/MlQ18c12Jp0f/pGPUAUY5aWY8tRZTHWZEMbaOl6mI=";

  subPackages = ["cmd/skaffold"];

  ldflags = let t = "github.com/GoogleContainerTools/skaffold/pkg/skaffold"; in [
    "-s" "-w"
    "-X ${t}/version.version=v${version}"
    "-X ${t}/version.gitCommit=${src.rev}"
    "-X ${t}/version.buildDate=unknown"
  ];

  nativeBuildInputs = [ installShellFiles ];

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
    maintainers = with maintainers; [ vdemeester ];
  };
}
