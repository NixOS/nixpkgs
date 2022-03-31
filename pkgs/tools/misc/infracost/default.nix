{ lib, buildGoModule, fetchFromGitHub, installShellFiles, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-LoIZbA1K1s3ZLHlRz2SOFxC4nv/Vgpae0qdxIcvAVRQ=";
  };
  vendorSha256 = "sha256-TfO3+pGxR9dPzigkx89a/Ak+tKiBa6Z0a6U4kIdRsSQ=";

  ldflags = [ "-s" "-w" "-X github.com/infracost/infracost/internal/version.Version=v${version}" ];

  subPackages = [ "cmd/infracost" ];

  nativeBuildInputs = [ installShellFiles ];

  # -short only runs the unit-tests tagged short
  checkFlags = [ "-short" ];
  checkPhase = ''
    runHook preCheck

    # remove tests that require networking
    rm cmd/infracost/{breakdown,diff,hcl,run}_test.go
    # checkFlags aren't correctly passed through via buildGoModule
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
