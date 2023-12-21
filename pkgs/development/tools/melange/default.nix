{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "melange";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sEmbfX7W1juymAxcWwDNxI8d/o7NS2S+0TJM6Vi9aQo=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # in format of 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-IkbXZu6iHRXjWFsLtRBDxwJio5sVVZvHylk1al0S+/c=";

  subPackages = [ "." ];

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

  postInstall = ''
    installShellCompletion --cmd melange \
      --bash <($out/bin/melange completion bash) \
      --fish <($out/bin/melange completion fish) \
      --zsh <($out/bin/melange completion zsh)
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/melange --help
    $out/bin/melange version 2>&1 | grep "v${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/chainguard-dev/melange";
    changelog = "https://github.com/chainguard-dev/melange/blob/${src.rev}/NEWS.md";
    description = "Build APKs from source code";
    license = licenses.asl20;
    maintainers = with maintainers; [ developer-guy ];
  };
}
