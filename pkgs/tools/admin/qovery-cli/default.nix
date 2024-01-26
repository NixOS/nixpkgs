{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.81.1";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-vzE2Slj69kJbXHNKM9mCBwPkbOqG3DkVa6y4DmfBdn0=";
  };

  vendorHash = "sha256-IDKJaWnQsOtghpCh7UyO6RzWgSZS0S0jdF5hVV7xVbs=";

  nativeBuildInputs = [
    installShellFiles
  ];

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
