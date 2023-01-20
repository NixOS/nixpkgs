{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "infracost";
  version = "0.10.12";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-sobIgUiFMLZ2/vkKO2DIQfEM92eRK1PV+oKaWfwk/nE=";
  };
  vendorSha256 = "sha256-QowKhRakXkkmKDI0vbSjWdftz4nXnjKNpdD4gscR3dM=";

  ldflags = [ "-s" "-w" "-X github.com/infracost/infracost/internal/version.Version=v${version}" ];

  subPackages = [ "cmd/infracost" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    # Feed in all tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    unset subPackages

    # checkFlags aren't correctly passed through via buildGoModule so we use buildFlagsArray
    # -short only runs the unit-tests tagged short
    # move to checkFlags after https://github.com/NixOS/nixpkgs/pull/173702
    buildFlagsArray+="-short"

    # remove tests that require networking
    rm cmd/infracost/{breakdown,diff,hcl,run}_test.go
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
