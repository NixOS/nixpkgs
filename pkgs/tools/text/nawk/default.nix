<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, bison, buildPackages, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "nawk";
  version = "20230909";
=======
{ lib, stdenv, fetchFromGitHub, bison, buildPackages }:

stdenv.mkDerivation rec {
  pname = "nawk";
  version = "20220122";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "onetrueawk";
    repo = "awk";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-sBJ+ToFkhU5Ei84nqzbS0bUbsa+60iLSz2oeV5+PXEk=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison installShellFiles ];
=======
    hash = "sha256-W5WkGk4WY3g1qSFjJxFBa8KY1k13oK6WAMg5GH6kKU4=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${if stdenv.buildPlatform.isDarwin then "clang" else "cc"}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 a.out "$out/bin/nawk"
<<<<<<< HEAD
    installManPage awk.1
=======
    install -Dm644 awk.1 "$out/share/man/man1/nawk.1"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstall
  '';

  meta = {
    description = "The one, true implementation of AWK";
    longDescription = ''
       This is the version of awk described in "The AWK Programming
       Language", by Al Aho, Brian Kernighan, and Peter Weinberger
       (Addison-Wesley, 1988, ISBN 0-201-07981-X).
    '';
    homepage = "https://www.cs.princeton.edu/~bwk/btl.mirror/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.konimex ];
    platforms = lib.platforms.all;
  };
}
