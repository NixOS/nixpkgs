{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.58.15";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sADeiFzVSk4Y0ZHvSoBVbtGp/YWO8ioYzZ+FXO9A7Tg=";
  };

  vendorHash = "sha256-Jwg+c+61kCytOkrwzJJCOjIGrv832G7n/kUDLGIJ5xA=";

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
