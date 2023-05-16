{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper
, nixosTests, rclone }:

buildGoModule rec {
  pname = "restic";
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.15.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kxxQlU3bKBjCb1aEtcLBmcnPg4KFgFlbFhs9MmbAgk8=";
=======
    hash = "sha256-YJBHk/B8+q5f0k5i5hpucsJK4T/cRu9Jv7+O6vlT64Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
    ./0001-Skip-testing-restore-with-permission-failure.patch
  ];

<<<<<<< HEAD
  vendorHash = "sha256-m5smEyAt9RxgvUf1pZqIhgja2h8MWfEgjJ4jUgrPMPY=";
=======
  vendorHash = "sha256-GWFaCfiE8Ph2uBTBI0E47pH+EJsMsMr1NDuaIGvyXRM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  passthru.tests.restic = nixosTests.restic;

  postPatch = ''
<<<<<<< HEAD
    rm cmd/restic/cmd_mount_integration_test.go
=======
    rm cmd/restic/integration_fuse_test.go
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postInstall = ''
    wrapProgram $out/bin/restic --prefix PATH : '${rclone}/bin'
  '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    $out/bin/restic generate \
      --bash-completion restic.bash \
<<<<<<< HEAD
      --fish-completion restic.fish \
      --zsh-completion restic.zsh \
      --man .
    installShellCompletion restic.{bash,fish,zsh}
=======
      --zsh-completion restic.zsh \
      --man .
    installShellCompletion restic.{bash,zsh}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installManPage *.1
  '';

  meta = with lib; {
    homepage = "https://restic.net";
    changelog = "https://github.com/restic/restic/blob/${src.rev}/CHANGELOG.md";
    description = "A backup program that is fast, efficient and secure";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm maintainers.dotlambda ];
  };
}
