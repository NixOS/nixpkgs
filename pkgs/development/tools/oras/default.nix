{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, oras }:

buildGoModule rec {
  pname = "oras";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oWDxrxCrBU0quSpRLXZ0w1COuImVj4FzAmv8574x76o=";
  };

  vendorHash = "sha256-51keQmj1eGT3rJysnfTWIl8xoHfz3NPL/qXegc3wwNc=";
=======
    hash = "sha256-NGkpmObFY3Z8sKBbgIwFAnIyVEFE0sRxgrX+3oXEVo0=";
  };

  vendorHash = "sha256-l2UuYrkFdZYaqQUW57y0OZyu1gPO22C+AwNdIYymV9k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [ "./test/e2e" ];

  ldflags = [
    "-s"
    "-w"
    "-X oras.land/oras/internal/version.Version=${version}"
    "-X oras.land/oras/internal/version.BuildMetadata="
    "-X oras.land/oras/internal/version.GitTreeState=clean"
  ];

  postInstall = ''
    installShellCompletion --cmd oras \
      --bash <($out/bin/oras completion bash) \
      --fish <($out/bin/oras completion fish) \
      --zsh <($out/bin/oras completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/oras --help
    $out/bin/oras version | grep "${version}"

    runHook postInstallCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = oras;
    command = "oras version";
  };

  meta = with lib; {
    homepage = "https://oras.land/";
    changelog = "https://github.com/oras-project/oras/releases/tag/v${version}";
    description = "The ORAS project provides a way to push and pull OCI Artifacts to and from OCI Registries";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk developer-guy ];
  };
}
