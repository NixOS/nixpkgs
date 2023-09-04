{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iurfG1g1I7ufraBLkbLATyM3SPfO5RhVF3k6SjExWUI=";
  };

  vendorHash = "sha256-U/yV+6WV8Oc0gLcYFyfOeBzzJdNwyyBk3jPRkH3LUrc=";

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
