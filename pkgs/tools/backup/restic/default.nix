{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper
, nixosTests, rclone }:

buildGoModule rec {
  pname = "restic";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "sha256-jQgUPZumcIDkZ4s7R8o5F/p/b4ilPJGMPFKvUU30WaY=";
  };

  patches = [
    # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
    ./0001-Skip-testing-restore-with-permission-failure.patch
  ];

  vendorSha256 = "sha256-DWfCjGXjZnZa2mXPmXQmvGDtXb0H1wJqCgVsDjdVy9U=";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  passthru.tests.restic = nixosTests.restic;

  postPatch = ''
    rm cmd/restic/integration_fuse_test.go
  '';

  postInstall = ''
    wrapProgram $out/bin/restic --prefix PATH : '${rclone}/bin'
  '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    $out/bin/restic generate \
      --bash-completion restic.bash \
      --zsh-completion restic.zsh \
      --man .
    installShellCompletion restic.{bash,zsh}
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
