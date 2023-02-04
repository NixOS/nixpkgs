{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.48.6";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-y6dhp5CUq9fJq7Vjib1g1P0TMCeBIcR32LHqNvMgjZI=";
  };

  vendorHash = "sha256-9BXuxeLL3MwefhtV2SLplAgY/KQI1crWrTNSSC4hUXw=";

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
