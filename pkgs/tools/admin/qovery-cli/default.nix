{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.61.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V3tKUIpSO1oGpkHjkFWAtBoe91va6q2HInZsHrjWhQ0=";
  };

  vendorHash = "sha256-5ikOmjJ2E+Kk8FAl6/Jm+k5HKlZJ1Ik3uZ/2sD5Eqok=";

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
