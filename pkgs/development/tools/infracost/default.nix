{ lib, buildGoModule, fetchFromGitHub, urfave-cli-completion }:

buildGoModule rec {
  pname = "infracost";
  version = "0.7.20";

  src = fetchFromGitHub {
    owner = "infracost";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3r9OdVhrZtWm/yhgvlUXcdrq2/lIJ3cuYgB/tvuaFcU=";
  };

  vendorSha256 = "sha256-wdO+cv4EOLJir4dqG9Rvis7vIr68bKPHupWESc9hNtg=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/infracost/infracost/internal/version.Version=v${version}")
  '';

  # runs terraform init which attempts to create files
  doCheck = false;

  # postInstall = ''
  #   mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
  #   ln -s ${urfave-cli-completion}/share/urfave-cli-complete/v2/bash_autocomplete \
  #         $out/share/bash-completion/completions/infracost
  #   ln -s ${urfave-cli-completion}/share/urfave-cli-complete/v2/zsh_autocomplete \
  #         $out/share/zsh/site-functions/_infracost
  # '';
  postInstall = ''
    ${urfave-cli-completion}/share/urfave-cli-complete/linkCompletions "v2" "infracost" "$out"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # Add statefile to avoid remote update checks
    export HOME="$TMPDIR"
    INFRACOST_DIR="$HOME/.config/infracost"
    mkdir -p "$INFRACOST_DIR"
    echo '{
      "installId": "00000000-0000-0000-0000-000000000000",
      "latestReleaseVersion": "v${version}",
      "latestReleaseCheckedAt": "1970-01-01T00:00:00Z"
    }' > "$INFRACOST_DIR/.state.json"

    $out/bin/infracost --help
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://infracost.io/";
    changelog = "https://github.com/infracost/infracost/releases/tag/v${version}/";
    description = "Cloud cost estimates for Terraform in your CLI and pull requests";
    longDescription = ''
      Infracost shows hourly and monthly cost estimates for a Terraform project.
      This helps developers, DevOps et al. quickly see the cost breakdown and compare different deployment options upfront.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
