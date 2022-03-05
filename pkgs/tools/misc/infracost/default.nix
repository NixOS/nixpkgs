{ lib, buildGoModule, fetchFromGitHub, installShellFiles, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-ukFY6Iy7RaUjECbMCMdOkulMdzUlsoBnyRiuzldXVc8=";
  };
  vendorSha256 = "sha256-D4tXBXtD3FlWvp4GPIuo/2p3MKg81DVPT5pKVOGe/5c=";

  ldflags = [ "-s" "-w" "-X github.com/infracost/infracost/internal/version.Version=v${version}" ];

  subPackages = [ "cmd/infracost" ];

  nativeBuildInputs = [ installShellFiles ];

  # -short only runs the unit-tests tagged short
  checkFlags = [ "-short" ];
  checkPhase = ''
    runHook preCheck

    # Remove tests that require networking
    rm cmd/infracost/{breakdown_test,diff_test,run_test}.go

    go test $checkFlags ''${ldflags:+-ldflags="$ldflags"} -v -p $NIX_BUILD_CORES ./...

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
