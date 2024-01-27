{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper
, nixosTests, rclone }:

buildGoModule rec {
  pname = "restic";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    hash = "sha256-nPOCncqdnwhmWrT11evBD4r5hpRb3DTdRej4zh4Q8lg=";
  };

  patches = [
    # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
    ./0001-Skip-testing-restore-with-permission-failure.patch
  ];

  vendorHash = "sha256-stz76S2dwVlBuGW9R7+Uqs51Xsq7L/4pgTqUZnu7YCQ=";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  passthru.tests.restic = nixosTests.restic;

  postPatch = ''
    rm cmd/restic/cmd_mount_integration_test.go
  '';

  postInstall = ''
    wrapProgram $out/bin/restic --prefix PATH : '${rclone}/bin'
  '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
    description = "A backup program that is fast, efficient and secure";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm maintainers.dotlambda ];
    mainProgram = "restic";
  };
}
