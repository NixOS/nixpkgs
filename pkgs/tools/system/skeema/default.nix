{ lib, buildGoModule, fetchFromGitHub, coreutils, runtimeShell, testers, skeema }:

buildGoModule rec {
  pname = "skeema";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "skeema";
    repo = "skeema";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-t0UACavJaDorAgxm2gA6FEsMfQ8UQEY/CZbFIFHwfIQ=";
=======
    hash = "sha256-JhOQKfJCaZc5PlDWPuYe1Ag9AHkw9RjEQ4N9MSda4rY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  preCheck =
    let
      skippedTests = [
        # Tests requiring network access to gitlab.com
        "TestDirRelPath"
        "TestParseDirSymlinks"

        # Flaky tests
        "TestShellOutTimeout"
      ];
    in
    ''
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")

      # Fix tests expecting /usr/bin/printf and /bin/echo
      substituteInPlace skeema_cmd_test.go \
        --replace /usr/bin/printf "${coreutils}/bin/printf"

      substituteInPlace internal/fs/dir_test.go \
        --replace /bin/echo "${coreutils}/bin/echo" \
        --replace /usr/bin/printf "${coreutils}/bin/printf"

      substituteInPlace internal/applier/ddlstatement_test.go \
        --replace /bin/echo "${coreutils}/bin/echo"

      substituteInPlace internal/util/shellout_unix_test.go \
        --replace /bin/echo "${coreutils}/bin/echo" \
        --replace /usr/bin/printf "${coreutils}/bin/printf"

      substituteInPlace internal/util/shellout_unix.go \
        --replace /bin/sh "${runtimeShell}"
    '';

  passthru.tests.version = testers.testVersion {
    package = skeema;
  };

  meta = with lib; {
    description = "Declarative pure-SQL schema management for MySQL and MariaDB";
    homepage = "https://skeema.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
