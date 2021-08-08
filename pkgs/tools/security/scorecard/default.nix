{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "scorecard";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OUQzgTQbeQfut/ATvUl9RTFZISiGaUhRjZi4Rh7BB2A=";
  };
  vendorSha256 = "sha256-/Ltw0qZkLr1qaQixLy5pvWZiNRJucp+bDiY7yVlWmqA=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/ossf/scorecard/v2/cmd.gitVersion=v${version}" ];

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    # Feed in all but the e2e tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    getGoDirs() {
      go list ./... | grep -v e2e
    }
  '';

  postInstall = ''
    installShellCompletion --cmd scorecard \
      --bash <($out/bin/scorecard completion bash) \
      --fish <($out/bin/scorecard completion fish) \
      --zsh <($out/bin/scorecard completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/scorecard --help
    $out/bin/scorecard version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/ossf/scorecard";
    changelog = "https://github.com/ossf/scorecard/releases/tag/v${version}";
    description = "Security health metrics for Open Source";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
