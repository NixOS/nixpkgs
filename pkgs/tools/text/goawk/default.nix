{ buildGoModule, fetchFromGitHub, lib, stdenv, gawk }:

buildGoModule rec {
  pname = "goawk";
<<<<<<< HEAD
  version = "1.24.0";
=======
  version = "1.22.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "goawk";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pce7g0MI23244t5ZK4UDOfQNt1m3tRpCahne0s+NRRE=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-8UoYGAmYmC0hcxLfkNac3flKyPBT/xsykuy+TvVosBI=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ gawk ];

  postPatch = ''
    substituteInPlace goawk_test.go \
      --replace "TestCommandLine" "SkipCommandLine" \
      --replace "TestDevStdout" "SkipDevStdout" \
      --replace "TestFILENAME" "SkipFILENAME" \
      --replace "TestWildcards" "SkipWildcards"

    substituteInPlace interp/interp_test.go \
      --replace "TestShellCommand" "SkipShellCommand"
  '';

  checkFlags = [
    "-awk"
    "${gawk}/bin/gawk"
  ];

  doCheck = (stdenv.system != "aarch64-darwin");

  meta = with lib; {
    description = "A POSIX-compliant AWK interpreter written in Go";
    homepage = "https://benhoyt.com/writings/goawk/";
    license = licenses.mit;
    mainProgram = "goawk";
    maintainers = with maintainers; [ abbe ];
  };
}
