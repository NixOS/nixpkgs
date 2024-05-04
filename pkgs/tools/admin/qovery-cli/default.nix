{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  qovery-cli,
  testers,
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.91.3";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-Kdk3T699cfyIDAt1vo8nQAmkR7TanNmjjI9v80PMTuE=";
  };

  vendorHash = "sha256-8u+V/D8Pr+VIy+6QbJYRQcfcpAbHEHN6TBitoYxgKHw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = qovery-cli;
    command = "HOME=$(mktemp -d); ${pname} version";
  };

  meta = with lib; {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    changelog = "https://github.com/Qovery/qovery-cli/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "qovery-cli";
  };
}
