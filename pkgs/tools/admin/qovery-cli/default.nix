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
  version = "0.97.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-DfRZU3hOgVM1J5m2Kqgofm/mERqc13c31J9wbTyV67Y=";
  };

  vendorHash = "sha256-maeoEs6He4Qb4EOYCx44Ly8713NFn/5qWgNjb1s2ajw=";

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
