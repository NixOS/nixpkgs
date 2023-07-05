{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "apko";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-02W9YOnV/zXopH3C9UNKu5gepNVS2gzoGa10uaKYu94=";
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
  vendorHash = "sha256-h1uAAL3FBskx6Qv9E5WY+UPeXK49WW/hFoNN4QyKevU=";

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
    # networking required to fetch alpine-keys
    # pulled out into a separate library next release
    "-skip=TestInitDB"
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
    license = licenses.asl20;
    maintainers = with maintainers; [ jk developer-guy ];
  };
}
