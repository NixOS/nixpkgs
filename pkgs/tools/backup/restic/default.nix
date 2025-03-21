{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  rclone,
  nixosTests,
  python3,
}:

buildGoModule (finalAttrs: {
  pname = "restic";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-odyKcpNAhk1dlVBhjrtmgKjWTOCMtooYOJ5p0J9OUFY=";
  };

  vendorHash = "sha256-cxOwVf1qZXJbDZC/7cGnKPNpwJnAk3OunKVZpwtI8pI=";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  nativeCheckInputs = [ python3 ];

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    restic = nixosTests.restic;
  };

  postInstall =
    ''
      wrapProgram $out/bin/restic --prefix PATH : '${rclone}/bin'
    ''
    + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
      $out/bin/restic generate \
        --bash-completion restic.bash \
        --fish-completion restic.fish \
        --zsh-completion restic.zsh \
        --man .
      installShellCompletion restic.{bash,fish,zsh}
      installManPage *.1
    '';

  # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
  checkFlags = [ "-skip=^TestRestoreWithPermissionFailure$|^TestMount$|^TestMountSameTimestamps$" ];

  meta = {
    homepage = "https://restic.net";
    changelog = "https://github.com/restic/restic/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Backup program that is fast, efficient and secure";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      mbrgm
      dotlambda
    ];
    mainProgram = "restic";
  };
})
