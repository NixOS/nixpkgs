{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "apko";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O1lU3b3dNmFcV0Dfkpw63Eu6AgLSLBi7MbF47OsjgL4=";
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
  vendorHash = "sha256-shnVJ6TcqWxUu1Ib2ewaz2VK4mi1Rt3R0Cmof9ilDJ4=";

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

  checkFlags = [
    # fails to run on read-only filesystem
    "-skip=(TestPublish|TestBuild|TestTarFS)"
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
    ];
  };
}
