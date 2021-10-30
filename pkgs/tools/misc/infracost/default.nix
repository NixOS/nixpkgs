{ lib, buildGoModule, fetchFromGitHub, installShellFiles, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-8XS30fRxHPady/snr3gfo8Ryiw9O7EeDezcYYZjod1w=";
  };
  vendorSha256 = "sha256-8r7v3526kY+rFHkl1+KEwNbFrSnXPlpZD6kiK4ea+Zg=";

  ldflags = [ "-s" "-w" "-X github.com/infracost/infracost/internal/version.Version=v${version}" ];

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ terraform ];
  # Short only runs the unit-tests tagged short
  checkFlags = [ "-v" "-short" ];
  checkPhase = ''
    runHook preCheck

    # Remove tests that require networking
    rm cmd/infracost/{breakdown_test,diff_test}.go
    # ldflags are required for some of the version testing
    go test ./... $checkFlags ''${ldflags:+-ldflags="$ldflags"}

    runHook postCheck
  '';

  postInstall = ''
    export INFRACOST_SKIP_UPDATE_CHECK=true
    installShellCompletion --cmd infracost \
      --bash <($out/bin/infracost completion --shell bash) \
      --fish <($out/bin/infracost completion --shell fish) \
      --zsh <($out/bin/infracost completion --shell zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export INFRACOST_SKIP_UPDATE_CHECK=true
    $out/bin/infracost --help
    $out/bin/infracost --version | grep "v${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://infracost.io";
    changelog = "https://github.com/infracost/infracost/releases/tag/v${version}";
    description = "Cloud cost estimates for Terraform in your CLI and pull requests";
    longDescription = ''
      Infracost shows hourly and monthly cost estimates for a Terraform project.
      This helps developers, DevOps et al. quickly see the cost breakdown and
      compare different deployment options upfront.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant jk ];
  };
}
