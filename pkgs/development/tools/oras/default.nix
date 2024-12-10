{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  oras,
}:

buildGoModule rec {
  pname = "oras";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras";
    rev = "v${version}";
    hash = "sha256-oWDxrxCrBU0quSpRLXZ0w1COuImVj4FzAmv8574x76o=";
  };

  vendorHash = "sha256-51keQmj1eGT3rJysnfTWIl8xoHfz3NPL/qXegc3wwNc=";

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
    mainProgram = "oras";
    license = licenses.asl20;
    maintainers = with maintainers; [
      jk
      developer-guy
    ];
  };
}
