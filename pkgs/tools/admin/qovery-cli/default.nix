{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.67.1";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mVn+Q4XZ+jJjHR+V5Rl/rPUZN/Tv7vVX7u6IDuJNdO0=";
  };

  vendorHash = "sha256-Fcm/f54zGgA742yhIVJxjv7Y2T8DblC71+hw5HTmOf0=";

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
  };
}
