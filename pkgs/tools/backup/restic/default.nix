{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nixosTests,
  rclone,
  python3,
}:

buildGoModule rec {
  pname = "restic";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    hash = "sha256-PTy/YcojJGrYQhdp98e3rEMqHIWDMR5jiSC6BdzBT/M=";
  };

  patches = [
    # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
    ./0001-Skip-testing-restore-with-permission-failure.patch
  ];

  vendorHash = "sha256-tU2msDHktlU0SvvxLQCU64p8DpL8B0QiliVCuHlLTHQ=";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  nativeCheckInputs = [ python3 ];

  passthru.tests = lib.optionalAttrs stdenv.isLinux {
    restic = nixosTests.restic;
  };

  postPatch = ''
    rm cmd/restic/cmd_mount_integration_test.go
  '';

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

  meta = with lib; {
    homepage = "https://restic.net";
    changelog = "https://github.com/restic/restic/blob/${src.rev}/CHANGELOG.md";
    description = "Backup program that is fast, efficient and secure";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [
      maintainers.mbrgm
      maintainers.dotlambda
    ];
    mainProgram = "restic";
  };
}
