{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "vexctl";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = "vex";
    rev = "v${version}";
    sha256 = "sha256-rDq62vkrZ8/76LERchxijmQCgo58KXlAIfv4SwI7egY=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+'%Y-%m-%dT%H:%M:%SZ'" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-7hhiJowtQv4JPqvpMiukL2JVgNeB5gi5X4p+AVGp4S0=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  postBuild = ''
    mv $GOPATH/bin/vex{,ctl}
  '';

  postInstall = ''
    installShellCompletion --cmd vexctl \
      --bash <($out/bin/vexctl completion bash) \
      --fish <($out/bin/vexctl completion fish) \
      --zsh <($out/bin/vexctl completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/vexctl --help
    $out/bin/vexctl version 2>&1 | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/chainguard-dev/vex/";
    description = "A tool to attest VEX impact statements";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
