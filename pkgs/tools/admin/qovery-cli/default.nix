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
  version = "0.93.6";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-5HGLzdygcM7GldtU24Arbr/AaGJYlyqEVIpc+arfFsw=";
  };

  vendorHash = "sha256-wGgzVtQc4e0thiM9fJb7BxJl348wCDZvPCx0+Qlw0mQ=";

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
