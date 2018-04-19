{ stdenv, fetchurl, libbsd }:

let
  rev = "89a718d88ec7466e721f3bbe9ede5ffe58061d78";
  fetchUtil = n: v: fetchurl {
    name = "${n}.c";
    url = "https://raw.githubusercontent.com/alpinelinux/aports/${rev}/main/musl/${n}.c";
    sha256 = v;
  };

in stdenv.mkDerivation {
  name = "musl-utils";

  srcs = stdenv.lib.mapAttrsToList fetchUtil {
    getconf = "0z14ml5343p5gapxw9fnbn2r72r7v2gk8662iifjrblh6sxhqzfq";
    getent = "0b4jqnsmv1hjgcz7db3vd61k682aphl59c3yhwya2q7mkc6g48xk";
    iconv = "1mzxnc2ncq8lw9x6n7p00fvfklc9p3wfv28m68j0dfz5l8q2k6pp";
  };

  unpackPhase = ":";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionals (stdenv.hostPlatform.libc == "glibc") [
    "-D_XOPEN_SOURCE=700"
    "-D_DEFAULT_SOURCE"

    "-I${stdenv.lib.getDev libbsd}/include/bsd"
    "-DLIBBSD_OVERLAY"
  ];
  NIX_LDFLAGS = stdenv.lib.optional (stdenv.hostPlatform.libc == "glibc") "-lbsd";

  buildInputs = stdenv.lib.optional (stdenv.hostPlatform.libc == "glibc") libbsd;

  buildPhase = ''
    mkdir -p bin
    for x in $srcs; do
      $CC $x -o bin/$(basename $(stripHash $x) .c)
    done
  '';

  installPhase = ''
    mkdir -p $out
    mv bin $out/
  '';
}
