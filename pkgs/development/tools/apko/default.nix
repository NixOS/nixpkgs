{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "apko";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Dyu/cPoYI8dm/p/91oL5g8ilz9ksw4i0opsPT6rGztc=";
=======
    sha256 = "sha256-gmBcN1lxzkkRpiUUWv87ji/G4Uy3DA8a6+6Qs+p/2mg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  vendorHash = "sha256-Jsp4rGIltszpQe05S3W+UFzPxhb6N5lCzUaZWBkXNWY=";
=======
  vendorSha256 = "sha256-3gRECgKvGqkgBzB3SSxm6/LxZG8RxhjoC6Q7DZj/Has=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  checkFlags = [
    # networking required to fetch alpine-keys
    # pulled out into a separate library next release
    "-skip=TestInitDB"
    # fails to build image on read-only filesystem
    "-skip=TestPublish"
  ];
=======
  preCheck = ''
    # requires network access to fetch alpine linux keyring
    substituteInPlace pkg/apk/apk_unit_test.go \
      --replace "TestInitKeyring" "SkipInitKeyring"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    installShellCompletion --cmd apko \
      --bash <($out/bin/apko completion bash) \
      --fish <($out/bin/apko completion fish) \
      --zsh <($out/bin/apko completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
<<<<<<< HEAD

    $out/bin/apko --help
    $out/bin/apko version 2>&1 | grep "v${version}"

=======
    $out/bin/apko --help
    $out/bin/apko version 2>&1 | grep "v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://apko.dev/";
    changelog = "https://github.com/chainguard-dev/apko/blob/main/NEWS.md";
    description = "Build OCI images using APK directly without Dockerfile";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ jk developer-guy ];
=======
    maintainers = with maintainers; [ jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
