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
  version = "0.94.13";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-LFVl4IlLoJyOdHv0rqL2GfUvLpp/8qT951fQkW8MHy4=";
  };

  vendorHash = "sha256-qrDadHGhjwsAIfIQIkUeT7Tehv1sTtsfzgPyKxc5zJE=";

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
