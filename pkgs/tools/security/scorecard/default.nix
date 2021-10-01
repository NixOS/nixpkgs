{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "scorecard";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U29NCZFXOhu0xLfDlJ1Q7m8TbAm+C6+ecYFhcI5gg6s=";
  };
  vendorSha256 = "sha256-hOATCXjBE0doHnY2BaRKZocQ6SIigL0q4m9eEJGKh6Q=";

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ossf/scorecard/v2/pkg.gitVersion=v${version}"
    "-X github.com/ossf/scorecard/v2/pkg.gitTreeState=clean"
  ];

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
