{ lib, stdenv, fetchFromGitHub, bison, buildPackages }:

stdenv.mkDerivation rec {
  pname = "nawk";
  version = "20220122";

  src = fetchFromGitHub {
    owner = "onetrueawk";
    repo = "awk";
    rev = version;
    hash = "sha256-W5WkGk4WY3g1qSFjJxFBa8KY1k13oK6WAMg5GH6kKU4=";
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
