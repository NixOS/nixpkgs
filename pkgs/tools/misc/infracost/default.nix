{ lib, buildGoModule, fetchFromGitHub, installShellFiles, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-lcvpNhfSgr8ky03sTo7kjnaLUJeIrzFqpYUjvQpT1Po=";
  };
  vendorSha256 = "sha256-TKs3xuZaO9PvlAcV5GDa3Jb36zeVWX3LcdcPxWR6KzE=";

  ldflags = [ "-s" "-w" "-X github.com/infracost/infracost/internal/version.Version=v${version}" ];

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ terraform ];
  checkPhase = ''
    runHook preCheck
    make test
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
