{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "apko";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ppWEMQs14GnnZr1wxe6YBQ9DtsN/EPiUSgYFOBdFbQU=";
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
  vendorHash = "sha256-8DsCLc1SovY8hupYc3AjOlp4JbeVeg1mbcVdLpvHUhI=";

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

  preCheck = ''
    # some tests require a writable HOME
    export HOME=$(mktemp -d)

    # some test data include SOURCE_DATE_EPOCH (which is different from our default)
    # and the default version info which we get by unsetting our ldflags
    export SOURCE_DATE_EPOCH=0
    ldflags=
  '';

  checkFlags = [
    # requires networking (apk.chainreg.biz)
    "-skip=TestInitDB_ChainguardDiscovery"
  ];

  postInstall = ''
    installShellCompletion --cmd apko \
      --bash <($out/bin/apko completion bash) \
      --fish <($out/bin/apko completion fish) \
      --zsh <($out/bin/apko completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/apko --help
    $out/bin/apko version 2>&1 | grep "v${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://apko.dev/";
    changelog = "https://github.com/chainguard-dev/apko/blob/main/NEWS.md";
    description = "Build OCI images using APK directly without Dockerfile";
    mainProgram = "apko";
    license = licenses.asl20;
    maintainers = with maintainers; [
      jk
      developer-guy
      emilylange
    ];
  };
}
