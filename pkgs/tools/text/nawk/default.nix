{ lib, stdenv, fetchFromGitHub, bison, buildPackages }:

stdenv.mkDerivation rec {
  pname = "nawk";
  version = "unstable-2021-02-15";

  src = fetchFromGitHub {
    owner = "onetrueawk";
    repo = "awk";
    rev = "c0f4e97e4561ff42544e92512bbaf3d7d1f6a671";
    sha256 = "kQCvItpSJnDJMDvlB8ruY+i0KdjmAphRDqCKw8f0m/8=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison ];
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${if stdenv.buildPlatform.isDarwin then "clang" else "cc"}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 a.out "$out/bin/nawk"
    install -Dm644 awk.1 "$out/share/man/man1/nawk.1"
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
