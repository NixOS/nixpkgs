{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "scorecard";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lTaFSQ3yyzQGdiKwev38iEpV+ELKg9f1rMYdbqVuiSs=";
  };
  vendorSha256 = "sha256-eFu954gwoL5z99cJGhSnvliAzwxv3JJxfjmBF+cx7Dg=";

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
