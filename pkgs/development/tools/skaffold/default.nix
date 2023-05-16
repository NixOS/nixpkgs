<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper }:

buildGoModule rec {
  pname = "skaffold";
  version = "2.7.0";
=======
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "skaffold";
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "skaffold";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uKrHWFyHuGX5dzrEvl7x305QgFOraS0L6J7gAFloUYc=";
=======
    hash = "sha256-feUR8R8mlKfSV2ct9EeAcEHJiK7Hb5PAXTnES9UG2Qc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  subPackages = ["cmd/skaffold"];

  ldflags = let t = "github.com/GoogleContainerTools/skaffold/v2/pkg/skaffold"; in [
    "-s" "-w"
    "-X ${t}/version.version=v${version}"
    "-X ${t}/version.gitCommit=${src.rev}"
    "-X ${t}/version.buildDate=unknown"
  ];

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles makeWrapper ];
=======
  nativeBuildInputs = [ installShellFiles ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/skaffold version | grep ${version} > /dev/null
  '';

  postInstall = ''
<<<<<<< HEAD
    wrapProgram $out/bin/skaffold --set SKAFFOLD_UPDATE_CHECK false

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
